class GoogleMap
	
	HEIGHT = 200
	WIDTH = 200
	ZOOM = 8
	
	def initialize(route)
		@route = route
	end
	
	def static_map_url(params={})
		attr = {:height=>HEIGHT, 
						:width=>WIDTH, 
						:zoom=>ZOOM}.merge!(params)
									
		url_params = static_params
		APP_CONFIG['google_static_map_url'] + '?' + url_params + "&sensor=false&size=#{attr[:height].to_s}x#{attr[:width].to_s}&zoom=#{attr[:zoom].to_s}"
	end
	
	
	def static_params
		json_coords = JSON.parse(@route.gmap_coords)
		# set url_params as an array in case there is no marker or path
		url_params = []
		if json_coords['marker']
			url_params = json_coords['marker'].collect do |marker|
				"markers=#{round_coord(marker['lat'])},#{round_coord(marker['lng'])}"
			end 
		end
		
		if json_coords['path']
			url_params += json_coords['path'].collect do |path|
				points = path.collect{ |coords| "#{round_coord(coords['lat'])},#{round_coord(coords['lng'])}" }.join("|")
				"path=#{URI.escape(points)}"
			end
		end
		
		url_params.join('&')
	end
	
	# round coordinates off to the correct number of siginificant digits
	def round_coord(coord)
		coord.to_f.round(6)
	end
	
end