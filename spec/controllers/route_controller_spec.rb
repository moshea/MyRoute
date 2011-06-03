require 'spec_helper'

describe RoutesController do
	
	CREATE_PARAMETERS = [
		{ :route => Factory.attributes_for(:route), :path => "redirect_to(route_path(assigns(:route)))" },
		# { :route => Factory.attributes_for(:route, :name=>""), :path => "render_template('new')" },
		# { :route => Factory.attributes_for(:route, :description=>""), :path => "redirect_to(route_path(assigns(:route)))" },
		# { :route => Factory.attributes_for(:route, :gmap_coords=>""), :path => "render_template('new')" },
	]
	before(:each) do
		activate_authlogic
		UserSession.create(Factory.build(:user))
	end
	
	describe :create do
		
		CREATE_PARAMETERS.each do |params|
			it "should redirect to show action if correct parameters are supplied" do
				post :create, {:route => params[:route] }
				response.should eval(params[:path])
			end
		end
		
	end
end