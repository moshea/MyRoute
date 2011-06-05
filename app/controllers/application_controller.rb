class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  def authenticate
  	unless current_user
  		redirect_to login_path(:url => request.url )
  		return false
  	end
  end
  
  def current_user_session
  	@current_user_session = @current_user_session || UserSession.find
  end
  
  def current_user
  	return @current_user if defined?(@current_user)
  	@current_user = current_user_session && current_user_session.record
  end
  
  # this will place the lat/lng location of a user in a session, so
  # it can be used when building new maps
  def current_user_geoip
    unless session[:location]
      lat, lng = GeoIP.instance.lat_lng(request.remote_ip)
      session[:location] = {:lat => lat, :lng => lng}
    end
    return session[:location]
  end
  
  # the search bar for finding routes may submit the default search terms
  # which will not find anything, so these need to be removed first
  def remove_default_search_terms(search_terms)
  	defaults = {"country_equals" => "Country", 
  							"sport_equals" => "Sport", 
  							"description_or_title_contains" => "Refine Search"}
  							
  	if search_terms && defaults
  		defaults.each_pair do |key, value|
  			search_terms.delete_if{ search_terms[key] == value }
  		end
  	end
  	search_terms
  end
end
