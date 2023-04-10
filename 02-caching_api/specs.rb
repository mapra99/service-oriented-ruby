require 'rspec'
require 'vcr'
require "./caching_api"

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end

RSpec.describe SimpsonsCharacter do
  subject(:character) { described_class.new }

  describe "#report" do
    let(:homer_simpson) { SimpsonsCharacter::Report.new(6660, "Homer Simpson", "homer simpson", "m") }

    it "calls the simpsons API and builds the report" do
      VCR.use_cassette("simpsons_api_homer") do
        expect(character.report(6660)).to eq(homer_simpson)
      end
    end

    describe "when the request is made multiple times" do
      before do
        VCR.use_cassette("simpsons_api_homer") do
          character.report(6660)
        end
      end

      it "uses the cached response" do
        expect(character.report(6660)).to eq(homer_simpson)
      end
    end

    describe "when an external cache is passed" do
      subject(:character) { described_class.new cache: cache }

      let(:homer_simpson_response) { '{"id":6660,"name":"Homer Simpson","normalized_name":"homer simpson","gender":"m"}' }
      let(:cache) { Moneta.new(:YAML, file: "store_test.yml") }

      before do
        cache["6660"] = homer_simpson_response
      end

      it "returns the cached data" do
        expect(character.report(6660)).to eq(homer_simpson)
      end
    end
  end
end