class AddZpidAndHersRatingToHomes < ActiveRecord::Migration
  def change
    add_column :homes, :zpid, :integer
    add_column :homes, :hers_rating, :integer
    add_index :homes, :zpid
  end
end
