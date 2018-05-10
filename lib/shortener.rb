module Shortener

  CHARSETS = {
      alphanum: ('a'..'z').to_a + (0..9).to_a,
      alphanumcase: ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
  }

  mattr_accessor :unique_key_length
  self.unique_key_length = 6

  mattr_accessor :charset
  self.charset = :alphanumcase

  mattr_accessor :default_redirect
  self.default_redirect = '/'

  def self.key_chars
    CHARSETS[charset]
  end
end