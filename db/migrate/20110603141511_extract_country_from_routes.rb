class ExtractCountryFromRoutes < ActiveRecord::Migration
  def self.up
  	
  	rename_column :routes, :country, :country_id
  	change_column :routes, :country_id, :integer
  end

  def self.down
  end
end
