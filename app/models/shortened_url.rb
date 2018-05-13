class ShortenedUrl < ApplicationRecord

  BASE_URL_HOST = 'ma.io'
  REGEX_URL_HAS_PROTOCOL = Regexp.new('\Ahttp:\/\/|\Ahttps:\/\/', Regexp::IGNORECASE)

  CHARSETS = {
      alphanum: ('a'..'z').to_a + (0..9).to_a,
      alphanumcase: ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
  }

  mattr_accessor :unique_key_length
  self.unique_key_length = 6

  mattr_accessor :charset
  self.charset = :alphanumcase

  before_validation :clean_url
  before_create :generate_unique_key

  validates :url, presence: true
  validates :url, uniqueness: { message: 'already exists' }
  validates :url, format: { with: /\A(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?\z/i,
                            message: 'is invalid' }

  has_many :visitors, dependent: :destroy

  attr_accessor :custom_key

  def generate
    begin
      self.save!
    rescue => e
      logger.error e
      nil
    end
  end

  def result_url
    uri = URI.parse(self.url)
    uri.scheme + '://' + BASE_URL_HOST + '/' + self.unique_key
  end

  def save_info(request)
    begin
      increment!(:use_count, 1)
      visitors << Visitor.new(visited_at: Time.now.utc, visitor_ip: request.remote_ip, visitor_agent: request.env['HTTP_USER_AGENT'])
    rescue => e
      logger.error e
      nil
    end
  end

  def visitors_info
    visitors.map.with_index {|v, i| { visitor_no: i+1, visitor_ip: v.visitor_ip, visitor_agent: v.visitor_agent, visited_at: v.visited_at }}
  end

  def self.extract_unique_key(url)
    url.strip.split('/').last
  end

  private

  def clean_url
    url = self.url.to_s.strip
    if url !~ REGEX_URL_HAS_PROTOCOL
      url = "http://#{url}"
    end
    self.url = URI.parse(url).normalize.to_s
  end

  def generate_unique_key
    begin
      self.unique_key = self.class.generate_unique_key!
    end while self.class.exists?(unique_key: unique_key)
  end

  def self.generate_unique_key!
    charset = key_chars
    (0...unique_key_length).map{ charset[rand(charset.size)] }.join
  end

  def self.key_chars
    CHARSETS[charset]
  end
end
