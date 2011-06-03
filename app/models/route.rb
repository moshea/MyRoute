class Route < ActiveRecord::Base
	
	validates_presence_of :name, {:message => "A name is needed!"}
	validates_presence_of :gmap_coords
	validates_presence_of :user_id
	
	has_one :user
	
	# take the last 3 added routes as featured
	def self.featured
		Route.all.last(3)
	end
	
	def static_map(params={})
		GoogleMap.new(self).static_map_url(params)
	end
	
end
