Rails.application.config.session_store :cookie_store, key: '_card_list_share_app_session', expire_after: 14.days, secure: true
# if Rails.env.production?
#     Rails.application.config.session_store :cookie_store, key: '_card_list_share_app_session', expire_after: 1.weeks, domain: 'mydomain.com'
#   else
#     Rails.application.config.session_store :cookie_store, key: '_card_list_share_app_session', domain: 'localhost'
#   end