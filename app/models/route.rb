class Route < ActiveRecord::Base
	
	validates_presence_of :name, {:message => "A name is needed!"}
	validates_presence_of :gmap_coords
	
	def static_map
		GoogleMap.new(self).static_map_url
	end
	
end
