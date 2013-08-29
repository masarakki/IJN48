FactoryGirl.define do
  factory :user, :class => Naka::User do
    sequence(:id)
    api_host '0.0.0.0'
    api_token 'token'
    api_at 0
  end
end
