class RouteSport < ActiveRecord::Base
	belongs_to :route
	belongs_to :sport
end