class Travel < ApplicationRecord
  belongs_to :user
  # to do add validations
  scope :for_user, ->(user) { where(user: user) }


  def dates_traveled
    start_date_str = start_date.present? ? start_date.strftime("%b %d, %Y") : nil
    end_date_str = end_date.present? ? end_date.strftime("%b %d, %Y") : nil

    if start_date_str.nil? && end_date_str.nil?
      "Not Available"
    elsif start_date_str.nil?
      end_date_str
    elsif end_date_str.nil?
      start_date_str
    else
      "#{start_date_str} - #{end_date_str}"
    end
  end
end
