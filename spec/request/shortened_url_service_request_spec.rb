require 'rails_helper'

RSpec.describe 'My Shortened URL Service', type: :request do
  describe 'CREATE URL' do
    it 'render 201' do
      post '/create', params: { url:'https://myapp.com/XYZ', format: :json }
      expect(response).to have_http_status(201)
    end

    it 'render 422' do
      post '/create', params: { url:'', format: :json }
      expect(response).to have_http_status(422)
    end
  end

  describe 'REDIRECT URL' do
    s_url = ShortenedUrl.create!(url: "http://myapp.com:3000/#{rand(100**100)}")

    it 'redirect to mail url' do
      get "/#{s_url.unique_key}"
      expect(response).to have_http_status(302)
      expect(s_url.reload.use_count).to eq(1)
      expect(s_url.reload.visitors.count).to eq(1)
    end
  end

  describe 'FETCH STATS' do
    url = ShortenedUrl.last
    s_url = url.result_url

    it 'veirfy' do
      get "/stats", params: { url: s_url, format: :json }
      expect(response).to have_http_status(200)
      expect(url.use_count).to eq(JSON.parse(response.body)['use_count'])
    end
  end
end