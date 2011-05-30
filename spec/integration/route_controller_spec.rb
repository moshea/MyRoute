require 'spec_helper'

describe "the new route page", :type => :request do
	
	it "renders the new route page when I visit new_route_path" do
		visit new_route_path
		page.should have_selector('input#route_name')
		page.should have_selector('textarea#route_description')
	end
	
	it "renders the new route with the name field prefilled if the name is passed to /routes/new" do
		visit root_path
		fill_in "route_name", :with => "routename"
		page.should have_xpath('//input[@id="route_name" and @value="routename"]')
	end
end