class HomeController < ApplicationController
	
	def index
		@featured_route = Route.last
		@new_route = Route.new
	end
end
