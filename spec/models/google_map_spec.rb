require 'spec_helper'

describe GoogleMap do
	it "should serve a url to the static google maps api" do
		gm = GoogleMap.new(Factory.build(:route))
		gm.static_map_url.should be_an_instance_of String
	end
	
	it "should use marker parameters to add markers to a map" do
		gm = GoogleMap.new(Factory.build(:route, :gmap_coords => '{"marker":[{"lat":"5","lng":"6"}]}'))
		url = gm.static_map_url
		params = URI.parse(url).query
		params.should include("markers=5.0,6.0")
		params.should match(/zoom=[\d]+/)
		params.should match(/sensor=[\w]+/)
	end
	
	it "should use path parameters to add a path to the map" do
		gm = GoogleMap.new(Factory.build(:route, :gmap_coords => '{"path":[[{"lat":"5","lng":"6"}, {"lat":"7","lng":"8"}]]}'))
		url = gm.static_map_url
		params = URI.parse(url).query
		params.should include("path=5.0,6.0%7C7.0,8.0")
	end
end