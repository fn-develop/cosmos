class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :code
      t.string :name
      t.boolean :enabled

      t.timestamps
    end
  end
end
