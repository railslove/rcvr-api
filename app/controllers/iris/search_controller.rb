class Iris::SearchController < Iris::IrisController

  def search
    render json: Iris::CompaniesSearch.call(search_string: params.permit(:full_text_search)[:full_text_search]).search_results
  end

end
