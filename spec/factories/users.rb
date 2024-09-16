FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
    first_name { "Test" }
    last_name { "User" }
  end
end