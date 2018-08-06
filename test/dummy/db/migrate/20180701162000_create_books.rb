class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.references :author, foreign_key: true
      t.string :name
      t.string :isbn

      t.timestamps
    end
  end
end
