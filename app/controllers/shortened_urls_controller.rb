class ShortenedUrlsController < ApplicationController
  before_action :find_unique_key, only: [:show]

  def index
    render json: {app: 'URL Shortener', owner: 'Anurag Tanwar'}
  end

  def create
    @shortened_url = ShortenedUrl.new(url_params)

    respond_to do |format|
      if @shortened_url.generate
        format.json { render json: { shortened_url: @shortened_url.result_url }, status: :created }
      else
        format.json { render json: @shortened_url.errors, status: :unprocessable_entity }
      end
    end
  end

  def stats
    unique_key = ShortenedUrl.extract_unique_key(params[:url])
    shortened_url = ShortenedUrl.find_by(unique_key: unique_key)

    respond_to do |format|
      if shortened_url.present?
        format.json { render json: { use_count: shortened_url.use_count, visitors_info: shortened_url.visitors_info }, status: :ok }
      else
        format.json { render json: { url: 'not found' }, status: :not_found }
      end
    end
  end

  def show
    if @shortened_url.nil?
      redirect_to  'http://www.myapp.com'
    else
      @shortened_url.save_info(request) if redirect_to @shortened_url.url
    end
  end

  private

  def find_unique_key
    @shortened_url = ShortenedUrl.find_by(unique_key: params[:id])
  end

  def url_params
    params.permit(:url)
  end
end