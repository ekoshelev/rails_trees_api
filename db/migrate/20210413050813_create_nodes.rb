class CreateNodes < ActiveRecord::Migration[6.0]
  def change
    create_table :nodes, id: false, primary_key: :id do |t|
      t.integer :id
      t.integer :parent_id

      t.timestamps
    end
  end
end
