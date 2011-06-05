class GoogleMap
	
	HEIGHT = 200
	WIDTH = 200
	ZOOM = 8
	
	def initialize(route)
		@route = route
	end
	
	def geocode_route
		if url = geocode_route_url
			uri = URI.parse(url)
			Rails.logger.debug("GoogleMap.geocode_route: url: #{url}")
			
			geocode_response = Net::HTTP.get_response(uri)
			Rails.logger.debug("GoogleMap.geocode_route: response: #{geocode_response.body.inspect}")
			name, iso_code = parse_geocode_data(geocode_response.body)
			Rails.logger.debug("GoogleMap.geocode_route: country: #{name}")
			
			country = Country.find_or_create_by_iso_code(:name => name, :iso_code => iso_code)
		  @route.country = country
		end
	end
	
	def parse_geocode_data(data)
		json = JSON.parse(data)
		country_data = nil
		json['results'].each do |result|
			if result['types'].include? "country"
				country_data = result
				break
			end
		end		
		country_code = country_data['address_components'].first['short_name']
		country_name = country_data['address_components'].first['long_name']
		
		return country_name, country_code
	end
	
	def geocode_route_url
		json_coords = JSON.parse(@route.gmap_coords)
		coords =
			if (marker = json_coords['marker'].first)
				"#{round_coord(marker['lat'])},#{round_coord(marker['lng'])}"
			else(path = json_coords['path'].first)
				"#{round_coord(path.first['lat'])},#{round_coord(path.first['lng'])}"
			end
			
		coords ? (APP_CONFIG['google_geocode_url'] + '?sensor=false&latlng=' + coords) : false
	end
	
	# generates a url to a static google map image which
	# will include paths and markers
	def static_map_url(params={})
		attr = {:height=>HEIGHT, 
						:width=>WIDTH, 
						:zoom=>ZOOM}.merge!(params)
									
		url_params = static_params
		APP_CONFIG['google_static_map_url'] + '?' + url_params + "&sensor=false&size=#{attr[:height].to_s}x#{attr[:width].to_s}"
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