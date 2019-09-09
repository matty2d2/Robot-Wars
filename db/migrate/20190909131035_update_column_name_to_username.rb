class UpdateColumnNameToUsername < ActiveRecord::Migration[6.0]
  def change
    rename_column :players, :name, :username
  end
end
