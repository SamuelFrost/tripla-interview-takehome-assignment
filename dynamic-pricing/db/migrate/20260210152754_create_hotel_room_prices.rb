class CreateHotelRoomPrices < ActiveRecord::Migration[8.1]
  def change
    create_table :hotel_room_prices do |t|
      t.string :period, null: false
      t.string :room, null: false
      t.string :hotel, null: false
      t.decimal :rate, precision: 12, scale: 2

      t.datetime :valid_to, null: false
      t.index :valid_to, name: "index_hotel_room_prices_on_valid_to"
      t.index [:period, :room, :hotel], unique: true, name: "index_hotel_room_prices_on_period_room_hotel_unique"
      t.timestamps
    end
  end
end
