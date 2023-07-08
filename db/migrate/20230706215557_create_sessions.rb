class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.belongs_to :user, foreign_key: true
      t.string :token

      t.timestamps
    end
  end
end