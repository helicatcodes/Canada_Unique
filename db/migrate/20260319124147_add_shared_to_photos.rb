class AddSharedToPhotos < ActiveRecord::Migration[8.1]
  def change
    add_column :photos, :shared, :boolean, default: false, null: false
  end
end
