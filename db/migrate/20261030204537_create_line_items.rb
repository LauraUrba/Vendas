class CreateLineItems < ActiveRecord::Migration[8.1]
  def change
    create_table :line_items do |t|
      t.references :produto, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true
      t.integer :quantidade, null: false, default: 1

      t.timestamps
    end
  end
end
