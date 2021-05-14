class CreateGroupEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :group_events do |t|
      t.date :start_date
      t.date :end_date
      t.integer :duration
      t.string :name
      t.text :description
      t.boolean :deleted
      t.boolean :published

      t.timestamps
    end
  end
end
