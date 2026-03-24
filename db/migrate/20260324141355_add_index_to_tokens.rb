class AddIndexToTokens < ActiveRecord::Migration[8.1]
  def change
    add_index :tokens, :token, unique: true
  end
end
