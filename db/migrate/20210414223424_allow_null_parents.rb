class AllowNullParents < ActiveRecord::Migration[6.0]
  def change
    change_column_null :nodes, :parent_id, true
  end
end
