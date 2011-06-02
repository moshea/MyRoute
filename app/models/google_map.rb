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
		url_params = json_coords['marker'].collect do |marker|
			"markers=#{marker['lat'].to_f.round(6)},#{marker['lng'].to_f.round(6)}"
		end
		
		url_params.join('&')
	end
	
end