# Creates the two tables required by the noticed gem for storing notifications. MJR
class CreateNoticedTables < ActiveRecord::Migration[8.1]
  def change
    # noticed_events: one row per broadcast, stores title and message as JSON params. MJR
    unless table_exists?(:noticed_events)
      create_table :noticed_events do |t|
        t.string :type
        t.jsonb :params
        t.integer :notifications_count, default: 0, null: false
        t.timestamps
      end
    end

    # noticed_notifications: one row per user per event, tracks read/seen status. MJR
    unless table_exists?(:noticed_notifications)
      create_table :noticed_notifications do |t|
        t.string :type
        t.references :noticed_event, null: false, foreign_key: true
        t.references :recipient, polymorphic: true, null: false
        t.datetime :read_at
        t.datetime :seen_at
        t.timestamps
      end
    end
  end
end
