class Like < ApplicationRecord
  belongs_to :user
  belongs_to :event_instance
end
