# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_18_163712) do

  create_table "zip_tax_rates", id: false, force: :cascade do |t|
    t.text "zip", limit: 5, null: false
    t.float "rate", null: false
    t.float "latitude"
    t.float "longitude"
    t.index ["latitude", "longitude"], name: "index_zip_tax_rates_on_latitude_and_longitude"
  end

end
