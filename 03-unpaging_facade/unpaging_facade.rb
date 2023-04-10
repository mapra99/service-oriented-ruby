require './news_client'

class UnpagingFacade
  def initialize(page_size:, page_fetcher:)
    @page_size = page_size
    @page_fetcher = page_fetcher
    @pages = []
  end

  def [](index)
    page_num = index / page_size
    offset = index % page_size

    page = fetch_page(page_num)
    page[offset]
  end

  private

  attr_reader :page_size, :page_fetcher, :pages
end
