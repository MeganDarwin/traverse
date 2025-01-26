class Travel < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :comments, as: :commentable, dependent: :destroy

  validates :name, presence: true
  validate :start_date_before_end_date

  scope :for_user, ->(user) { where(user: user) }

  def dates_traveled
    start_date_str = start_date.present? ? start_date.strftime("%b %d, %Y") : nil
    end_date_str = end_date.present? ? end_date.strftime("%b %d, %Y") : nil

    if start_date_str.nil? && end_date_str.nil?
      "Not Provided"
    elsif start_date_str.nil?
      end_date_str
    elsif end_date_str.nil?
      start_date_str
    else
      "#{start_date_str} - #{end_date_str}"
    end
  end

  private

  def start_date_before_end_date
    if start_date.present? && end_date.present? && start_date >= end_date
      errors.add(:start_date, "must be before the end date")
    end
  end
end
