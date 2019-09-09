class CreateBatrobs < ActiveRecord::Migration[6.0]
  def change
    create_table :batrobs do |t|
      t.integer :hitpoints
      t.integer :robot_id
      t.integer :battle_id
    end
  end
end
