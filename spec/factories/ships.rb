FactoryGirl.define do
  factory :ship, :class => Naka::Models::Ship do
    sequence(:id)
    sequence(:ship_id)
    lv 1
    fuel 10
    bull 10
    hp { Naka::Models::Ship::Hp.new(30, 30) }
    repairs_in nil
    condition 49

    locked false

    trait :small_damaged do
      hp { Naka::Models::Ship::Hp.new(20, 30) }
      repairs_in 60 * 3
    end

    trait :damaged do
      hp { Naka::Models::Ship::Hp.new(15, 30) }
      repairs_in 60 * 10
    end

    trait :fatal_damaged do
      hp { Naka::Models::Ship::Hp.new(8, 32) }
      repairs_in 60 * 60 * 12
    end

    trait :tired do
      condition 29
    end

    trait :high do
      condition 70
    end
  end

  factory :ship_master, :class => OpenStruct do
    sequence(:id)
    name :name
    type :type
    fuel 20
    bullet 30
  end
end
