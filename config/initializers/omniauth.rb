Rails.application.config.middleware.use OmniAuth::Builder do
  provider :line, ENV['LINE_CHANNEL_ID'], ENV['LINE_CHANNEL_SECRET']
end

OmniAuth.config.allowed_request_methods = %i[post get]
OmniAuth.config.silence_get_warning = true
