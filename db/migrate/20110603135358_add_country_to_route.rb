class AddCountryToRoute < ActiveRecord::Migration
  def self.up
  	add_column :routes, :country, :string
  end

  def self.down
  	remove_column :routes, :country
  end
end
