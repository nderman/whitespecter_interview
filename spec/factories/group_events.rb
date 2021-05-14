# frozen_string_literal: true
FactoryBot.define do
  factory :group_event do
    start_date { Faker::Date.backward(days: 30) }
    end_date { Faker::Date.forward(days: 30) }
    duration { (end_date - start_date).to_i }
    name { Faker::FunnyName.name }
    description { Faker::Lorem.paragraphs(number: 4).map { |pr| "<p>#{pr}</p>" }.join }
    deleted { false }
    published { false }
  end
end
