require 'json'
require 'http'
require 'moneta'

class SimpsonsCharacter
  Report = Struct.new(:id, :name, :normalized_name, :gender)

  def initialize(cache: Moneta.new(:YAML, file: "store.yml", expires: 300))
    @cache = cache
  end

  def report(id)
    cached_body = cache[id.to_s]
    if !cached_body
      url = "https://api.sampleapis.com/simpsons/characters/#{id}"
      response = HTTP.get(url)
      cache[id.to_s] = response.body.to_s
    end

    response_body = cache[id.to_s]
    data = JSON.parse(response_body)

    attributes = data.slice("id", "name", "normalized_name", "gender").values
    Report.new(*attributes)
  end

  private

  attr_reader :cache
end
