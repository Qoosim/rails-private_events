class User < ApplicationRecord

  before_save { self.email = email.downcase }
  include UsersHelper

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  validates :username, presence: true, length: { minimum: 5, maximum: 50 }
  validates :password, presence: true, length: { minimum: 6, maximum: 255 }
  validates :email, presence: true, length: { minimum: 10, maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

 has_many :attendances, foreign_key: :event_attendee_id  # event_creator_id
 has_many :attended_events, through: :attendances
 has_many :created_events, foreign_key: :creator_id, class_name: 'Event'

 has_secure_password

 def upcoming_events
   attended_events.select { |event| event.current_time >= Date.today }
 end

 def past_events
   attended_events.select { |event| event.current_time < Date.today }
 end
end
