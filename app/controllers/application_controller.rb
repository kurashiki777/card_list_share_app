class ApplicationController < ActionController::Base
  helper_method :logged_in?
  include Rails.application.routes.url_helpers
end
