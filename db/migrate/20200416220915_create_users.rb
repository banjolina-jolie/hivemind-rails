class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid do |t|
      t.timestamps null: false
      t.string :name
      t.boolean :is_admin, default: false
    end
  end
end
