require 'spec_helper'

describe "the new route page", :type => :request do
	
	before(:each) do
		@user = Factory.build(:user)
	end
	
	it "renders the new route page when I visit new_route_path" do
		visit root_path
		click_link "Register"
		fill_in "user_username", :with => @user.username
		fill_in "user_email", :with => @user.email
		fill_in "user_password", :with => @user.password
		fill_in "user_password_confirmation", :with => @user.password
		click_button "Create User"

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