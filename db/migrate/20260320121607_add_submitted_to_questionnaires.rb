class AddSubmittedToQuestionnaires < ActiveRecord::Migration[8.1]
  def change
    add_column :questionnaires, :submitted, :boolean, default: false, null: false
  end
end
