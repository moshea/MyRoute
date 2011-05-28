class HomeController < ApplicationController
	
	def index
		@featured_route = Route.last
	end
end
