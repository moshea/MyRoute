class Sport < ActiveRecord::Base
	has_many :route_sports
	has_many :routes, :through => :route_sports
end