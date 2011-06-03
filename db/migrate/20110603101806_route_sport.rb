class RouteSport < ActiveRecord::Migration
  def self.up
  	create_table :route_sports do |t|
  		t.integer :route_id
  		t.integer :sport_id
  	end
  end

  def self.down
  	drop_table :route_sports
  end
end
