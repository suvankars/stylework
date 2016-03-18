class Api::V1::BaseController < ActionController::Metal
  # include ActionController::MimeResponds
  include AbstractController::Rendering
  include ActionController::ImplicitRender #F**U Implicit Render, I lose one night sleep to find you :(
  include AbstractController::Callbacks
  include ActionView::Layouts
  extend Apipie::DSL::Controller
  append_view_path "#{Rails.root}/app/views"
end
