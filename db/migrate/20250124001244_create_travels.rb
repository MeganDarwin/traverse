class CreateTravels < ActiveRecord::Migration[8.0]
  def change
    create_table :travels do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.boolean :favorite
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
