class Country < ActiveRecord::Base
	has_many :routes
	
	validates_uniqueness_of :iso_code
end