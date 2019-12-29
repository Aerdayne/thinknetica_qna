class AddUniqueIndexToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_index :subscriptions, %i[question_id user_id], unique: true
  end
end
