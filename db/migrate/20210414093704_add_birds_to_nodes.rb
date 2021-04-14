class AddBirdsToNodes < ActiveRecord::Migration[6.0]
  def change
    add_column :nodes, :bird_id, :string
  end
end
