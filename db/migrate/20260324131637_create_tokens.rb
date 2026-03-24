class CreateTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :tokens do |t|
      t.string :email
      t.string :token
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
