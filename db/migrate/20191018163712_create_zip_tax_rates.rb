class CreateZipTaxRates < ActiveRecord::Migration[6.0]
  def change
    create_table :zip_tax_rates, id: false, primary_key: :zip  do |t|
      t.text :zip, limit: 5, null: false
      t.float :rate, null: false
      t.float :latitude
      t.float :longitude
    end

    add_index :zip_tax_rates, [:latitude, :longitude]
  end
end
