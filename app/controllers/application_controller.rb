class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  def current_user_session
  	@current_user_session = @current_user_session || UserSession.find
  end
  
  def current_user
  	return @current_user if defined?(@current_user)
  	@current_user = current_user_session && current_user_session.record
  end
  
  # the search bar for finding routes may submit the default search terms
  # which will not find anything, so these need to be removed first
  def remove_default_search_terms(search_terms)
  	defaults = {"country_equals" => "Country", 
  							"sport_equals" => "Sport", #
  							"description_or_title_contains" => "Refine Search"}
  							
  	defaults.each_pair do |key, value|
  		search_terms.delete_if{ search_terms[key] == value }
  	end
  	search_terms
  end
end
