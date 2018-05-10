class Visitor < ApplicationRecord
  validates :visited_at, :visitor_ip, :visitor_agent, presence: true
end
