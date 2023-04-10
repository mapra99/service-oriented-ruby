require 'spec_helper'
require "./news_client"

RSpec.describe NewsClient do
  subject(:client) { described_class.new }

  describe "#top_headlines" do
    subject(:result) { client.top_headlines(country:, page:, page_size:) }

    let(:country) { "us" }
    let(:page) { 1 }
    let(:page_size) { 10 }
    let(:first_article) { result.first.to_h }

    it "returns 10 top headlines" do
      VCR.use_cassette("news_api_top_headlines") do
        expect(result.size).to eq(10)
      end
    end

    it "returns each headline with the expected shape" do
      VCR.use_cassette("news_api_top_headlines") do
        expect(first_article).to include(
          :source,
          :author,
          :title,
          :description,
          :url,
          :url_to_image,
          :published_at,
          :content
        )
      end
    end
  end
end
