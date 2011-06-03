class Route < ActiveRecord::Base
	
	validates_presence_of :name, {:message => "A name is needed!"}
	validates_presence_of :gmap_coords
	validates_presence_of :user_id
	
	belongs_to :user
	belongs_to :country
	has_many :route_sports
	has_many :sports, :through => :route_sports
	
	# take the last 3 added routes as featured
	def self.featured
		Route.all.last(3)
	end
	
	def static_map(params={})
		GoogleMap.new(self).static_map_url(params)
	end
	
	def geocode
		GoogleMap.new(self).geocode_route
	end
	
end