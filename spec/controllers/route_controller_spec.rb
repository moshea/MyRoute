require 'spec_helper'
describe RoutesController do
	
	describe :create do
		it "should redirect to show action if correct parameters are supplied" do
			post :create, {:route=>{:name=>'abc', :description=>'fdsa'}}
			response.should redirect_to(route_path(assigns(:route)))
		end
	end
end