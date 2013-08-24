FactoryGirl.define do
  factory :dock, :class => Naka::Models::Dock do
    sequence(:id)
    member_id 1

    trait :blank do
      ship_id nil
      repairs_at nil
      state false
    end

    trait :short do
      sequence(:ship_id)
      repairs_at { Time.now + 600 }
      state true
    end

    trait :long do
      sequence(:ship_id)
      repairs_at { Time.now + 60 * 60 * 12 }
      state true
    end
  end
end
