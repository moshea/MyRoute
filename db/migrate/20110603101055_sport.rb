class Sport < ActiveRecord::Migration
  def self.up
  	create_table :sports do |t|
  		t.string :name
  	end
  end

  def self.down
  	drop_table :sports
  end
end
