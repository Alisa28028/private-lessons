class Video < ApplicationRecord
  belongs_to :event, optional: true
  belongs_to :event_instance, optional: true
  belongs_to :user
end
