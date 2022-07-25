class CreateStories < ActiveRecord::Migration[7.0]
  def change
    create_table :stories do |t|
      t.string :headline
      t.text :body
      t.string :status
      t.references :chief, null: false, foreign_key: { to_table: 'users' }
      t.references :writer, null: true, foreign_key: { to_table: 'users' }
      t.references :reviewer, null: true, foreign_key: { to_table: 'users' }
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
