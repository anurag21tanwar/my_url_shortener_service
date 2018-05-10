class CreateShortenedUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :shortened_urls do |t|
      t.text :url, null: false, length: 1024
      t.string :unique_key, limit: 10, null: false
      t.integer :use_count, null: false, default: 0

      t.timestamps
    end

    add_index :shortened_urls, :unique_key, unique: true
    add_index :shortened_urls, :url, length: 1024
  end
end
