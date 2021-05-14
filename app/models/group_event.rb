# frozen_string_literal: true
class GroupEvent < ApplicationRecord
  before_validation :calculate_dates_duration
  validate :end_cannot_be_before_start, :end_start_duration, :publish_require_all_fields

  private

  def end_cannot_be_before_start
    if start_date.present? && end_date.present? && (end_date < start_date)
      errors.add(:group_event, "Start date must be before end")
    end
  end

  def end_start_duration
    if start_date.present? && end_date.present? && duration.present? && (end_date - start_date) != duration
      errors.add(:group_event, "Dates do not match duration")
    end
  end

  def publish_require_all_fields
    if published.present? && (published == true) && !attributes_complete?
      errors.add(:group_event, "Cannot save without all fields")
    end
  end

  def calculate_dates_duration
    if start_date.present? && end_date.present? && !duration.present?
      self.duration = (end_date - start_date).to_i
    end
    if !start_date.present? && end_date.present? && duration.present?
      self.start_date = end_date - duration.days
    end
    if start_date.present? && !end_date.present? && duration.present?
      self.end_date = start_date + duration.days
    end
  end

  def attributes_complete?
    complete = true
    attributes.each do |k, v|
      if k.in?(['start_date', 'end_date', 'duration', 'name', 'description', 'location'])
        complete = complete && !v.nil? && v != [] && v != [""]
      end
    end
    complete
  end
end
