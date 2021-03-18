class Iris::SearchController < Iris::IrisController

  include Iris::SearchHelper

  def search
    render json: search_for_locations(params.permit(:full_text_search)[:full_text_search])
  end

end
