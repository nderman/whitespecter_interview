class AddLocationToGroupEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :group_events, :location, :string
  end
end
