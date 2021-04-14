class AddLtreeToNode < ActiveRecord::Migration[6.0]
  def change
    add_column :nodes, :path, :ltree

    add_index :nodes, :path, using: :gist
  end
end
