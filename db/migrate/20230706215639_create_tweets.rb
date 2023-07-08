class CreateTweets < ActiveRecord::Migration[6.1]
  def change
    create_table :tweets do |t|
      t.belongs_to :user, foreign_key: true
      t.string :message

      t.timestamps
    end
  end
end
