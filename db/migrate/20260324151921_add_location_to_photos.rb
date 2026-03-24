class AddLocationToPhotos < ActiveRecord::Migration[8.1]
  def change
    add_column :photos, :location, :string
  end
end
