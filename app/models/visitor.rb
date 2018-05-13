class Visitor < ApplicationRecord
  validates :visited_at, :visitor_ip, presence: true
end
