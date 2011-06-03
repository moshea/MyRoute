class HomeController < ApplicationController
	
	def index
		@featured_routes = Route.featured
		@new_route = Route.new
	end
end
