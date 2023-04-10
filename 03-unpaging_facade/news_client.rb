require 'http'
require 'uri'
require 'dotenv/load'

class NewsClient
  Article = Struct.new(:source, :author, :title, :description, :url, :url_to_image, :published_at, :content)

  def initialize(client: nil)
    @client = client || HTTP.headers(accept: "application/json")
                            .headers("X-Api-Key" => ENV.fetch("NEWS_API_KEY"))
  end

  def top_headlines(country:, page:, page_size:)
    url = base_url.dup
    url.path = "/v2/top-headlines"
    url.query = "country=#{country}&page=#{page}&pageSize=#{page_size}"

    response = client.get(url)
    raise StandardErrror, "Request failed" if !response.status.success?

    body = response.parse
    body["articles"].map do |article_data|
      Article.new(
        article_data["source"],
        article_data["author"],
        article_data["title"],
        article_data["description"],
        article_data["url"],
        article_data["urlToImage"],
        article_data["publishedAt"],
        article_data["content"]
      )
    end
  end

  private

  attr_reader :client, :cache

  def base_url
    @base_url ||= URI::HTTPS.build(host: ENV.fetch("NEWS_API_HOST"))
  end
end
