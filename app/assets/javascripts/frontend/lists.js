//For gmap auto complete

$(function() {
  var completer;

  completer = new GmapsCompleter({
    inputField: '#gmaps-input-address',
    errorField: '#gmaps-error'

  });

  completer.autoCompleteInit({
    country: "in"
  })
});


   
rePositionMarkers = function(data){
  var data_hash = data;
      var handler = Gmaps.build('Google');
      handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
        markers = handler.addMarkers(data_hash);
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
    });
};
reRenderRideList = function(listings){
  //alert("Going to refresh ride list");
  //Tried out partial rendering but that re-rendering the whole partial 
  //TBD find a better way to update dom on success respose 
  $("#rides").empty();
  $(function() {
    $.each(listings, function(i, list) {
      
      var image = list.images[0]
      var image_url = image["thumbnail_url"]
       $('#rides').append('<hr />')

      $('<ride-list>').append(
        $('<li class="list"' + 'id=list_' + list.id + '>').append( 
          $('<a data-remote="true" href="/lists/' + list.id + '\">').append(
            $('<div class="ride-details">').append(

              $('<div class="ride-image">').append('<img src=' + image_url +'>'),

              $('<div class="ride-body">').append(
                $('<h4 class="media-heading">').text(list.ride_title),
                $('<p>').text(list.ride_description)
              )
            )
          )
        )
      ).appendTo('#rides');
    });
  });

};


//On Submit a search on map
//Reposition all available rides on map and update ride-list

$(function(){ 
  $("#ajax").click(function(){
    var valuesToSubmit = $('#gmaps-input-address').val();
    $.ajax({
        type: "GET",
        url: $(this).attr('action'),
        data: { search: valuesToSubmit},
        dataType: "JSON" 
    }).success( function(data, status, xhr){
        var listings = data["lists"];
        var geoLocation = data["hash"];
        rePositionMarkers(geoLocation);
        reRenderRideList(listings);
    });
    return false; 
  })
});  





//For Schedule Calendar 
var updateEvent;
var display;
var refetch_events_and_close_dialog;

$(document).ready(function() {

  var dialog_form = $('<div id="dialog-form">Loading form...</div>').dialog({
    autoOpen: false,
    height: 350,
    width: 700,
    modal: true,
    buttons: {
        'Create event': function () {
            $(this).dialog('close');
        },
        Cancel: function () {
            $(this).dialog('close');
        }
    },

    close: function () {
    }
  });
  return $('#calendar').fullCalendar({
    editable: true,
    selectable: true,
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    defaultView: 'month',
    height: 600,
    height: 600,
    slotMinutes: 30,
    eventSources: [
      {
        url: '/lists/get_lists'
      }
    ],
    timeFormat: 'h:mm',
    dragOpacity: "0.5",

    eventDrop: function( event, delta, revertFunc, jsEvent, ui, view ){
      move(event, delta, revertFunc, jsEvent, ui, view);
    },
    eventResize: function(event, delta, revertFunc, jsEvent, ui, view ){
      resize(event, delta, revertFunc, jsEvent, ui, view);
    },
    eventClick: function(event, jsEvent, view){
      updateEventDetails(event);
    },
    select: function( startDate, endDate, allDay, jsEvent, view ) {
      display({ 
        starttime: new Date(startDate.toDate()), 
        endtime:   endDate.toDate(), 
        allDay:    allDay 
      })
    },
  });
});

refetch_events_and_close_dialog = function (){
      $('#calendar').fullCalendar('refetchEvents');
      $('.dialog:visible').dialog('destroy');
    }

display = function(options) {
  $('#event_form').remove('');
  fetch(options);
},

destroy = function(action_url){
  console.log(action_url)
  $.ajax({
    dataType: 'script',
    type: 'delete',
    url: action_url,
    success: refetch_events_and_close_dialog
  });
},

render= function(options){
      $('#event_form').trigger('reset');
      
      var startTime = options['starttime']
      var endTime = options['endtime'];
      var type = '#schedule_start_time';
      var time = startTime
      var $year = $(type + '_1i'), $month = $(type + '_2i'), $day = $(type + '_3i'), $hour = $(type + '_4i'), $minute = $(type + '_5i')
      $year.val(time.getFullYear());
      $month.prop('selectedIndex', time.getUTCMonth());
      $day.prop('selectedIndex', time.getUTCDate() - 1);
      $hour.prop('selectedIndex', time.getUTCHours());
      $minute.prop('selectedIndex', time.getUTCMinutes());

      var type = '#schedule_end_time';
      var time = endTime;
      var $year = $(type + '_1i'), $month = $(type + '_2i'), $day = $(type + '_3i'), $hour = $(type + '_4i'), $minute = $(type + '_5i')
      console.log($year.val(time.getFullYear()));
      $year.val(time.getFullYear());
      $month.prop('selectedIndex', time.getMonth());
      $day.prop('selectedIndex', time.getDate() - 1);
      $hour.prop('selectedIndex', time.getUTCHours());
      $minute.prop('selectedIndex', time.getUTCMinutes());

      $('#create_event_dialog').dialog({
        title: 'New Event',
        modal: true,
        width: 500,
        close: function(event, ui) { $('#create_event_dialog').dialog('destroy') }
      });
},

// make_it_work_setTime =  function(type, time) {
//   //$('#event_form').remove('')

//   var $year = $(type + '_1i'), $month = $(type + '_2i'), $day = $(type + '_3i'), $hour = $(type + '_4i'), $minute = $(type + '_5i')
//   console.log($year.val(time.getFullYear()));
//   $year.val(time.getFullYear());
//   $month.attr('selectedIndex', time.getMonth());
//   $day.attr('selectedIndex', time.getDate() - 1);
//   $hour.attr('selectedIndex', time.getHours());
//   $minute.attr('selectedIndex', time.getMinutes());
// },

fetch = function(options){
  var list_id = $("#list").data('list').list_id
  $.ajax({
    type: 'get',
    dataType: 'script',
    async: true,
    url: "/lists/" + list_id + "/schedules/new",
    success: function(){ render(options) }
  });
},

 move = function(the_event, delta, revertFunc, jsEvent, ui, view ){
  var list_id = $("#list").data('list').list_id

    $.ajax({
        url : "/lists/" + list_id + "/schedules/" + the_event.id +"/move" ,
        type : "PATCH",
        data:  'title=' + the_event.title + '&delta=' + delta,
        dataType: 'script',
        async: true,
        error: function(xhr){
          revertFunc();
          alert(JSON.parse(xhr.responseText)["message"])
        }
    }); 
},

resize = function(the_event, delta, revertFunc, jsEvent, ui, view ) {
  //Move and resize basically does the same job; add delta to start and end time
  // For move add delta to both start and end time
  // For resize add delta to only end time
  //For seperation of concern create two method and two action in controller to uodate data
  //There Might be a better way we can handle dis.

  var list_id = $("#list").data('list').list_id

  $.ajax({
      url : "/lists/" + list_id + "/schedules/" + the_event.id +"/resize" ,
      type : "PATCH",
      data:  'title=' + the_event.title + '&delta=' + delta,
      dataType: 'script',
      async: true,
      error: function(xhr){
        revertFunc();
        alert(JSON.parse(xhr.responseText)["message"])
      }
  }); 
 
};



renderUpdateForm = function(){

};

updateEventDetails = function(schedule){
  alert("Going to update")
  var list_id = $("#list").data('list').list_id
  console.log(event);
  $.ajax({
        type: 'GET',
        dataType: 'script',
        async: true,
        url : "/lists/" + list_id + "/schedules/" + schedule.id + "/edit",

        success: function(){ renderUpdateForm() }
  });
  
  $('#event_desc_dialog').dialog({
        title: "Update Schedules",
        modal: true,
        width: 500,
        close: function(event, ui){ $('#event_desc_dialog').html(''); $('#event_desc_dialog').dialog('destroy') }
  }); 
}  

$(document).ready(function(){
  $('#create_event_dialog, #event_desc_dialog').on('submit', "#event_form, #modify_form", function(event) {
    var $spinner = $('.spinner');
    event.preventDefault();
    $.ajax({
      type: "POST",
      data: $(this).serialize(),
      url: $(this).attr('action'),
      beforeSend: show_spinner,
      complete: hide_spinner,
      success: refetch_events_and_close_dialog,
      error: handle_error
    });

    
    function show_spinner() {
      $spinner.show();
    }

    function hide_spinner() {
      $spinner.hide();
    }

    function handle_error(xhr) {
      alert(xhr.responseText);
    }
  })

  $('input.ride').on('change', function() {
    $('input.ride').not(this).prop('checked', false);  
  });

});

