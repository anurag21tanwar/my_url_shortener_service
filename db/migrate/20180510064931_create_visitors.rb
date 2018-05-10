class CreateVisitors < ActiveRecord::Migration[5.2]
  def change
    create_table :visitors do |t|
      t.integer :shortened_url_id, null: false
      t.datetime :visited_at, null: false
      t.string :visitor_ip
      t.string :visitor_agent

      t.timestamps
    end

    add_index :visitors, :shortened_url_id
  end
end