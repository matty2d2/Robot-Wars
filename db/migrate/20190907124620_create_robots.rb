class CreateRobots < ActiveRecord::Migration[6.0]
  def change
    create_table :robots do |t|
      t.string :name
      t.integer :player_id
      t.integer :hitpoints, :default => 100
      t.integer :wins, :default => 0
    end
  end
end
