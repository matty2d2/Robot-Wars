class CreateBattles < ActiveRecord::Migration[6.0]
  def change
    create_table :battles do |t|
      t.string :winner
    end
  end
end
