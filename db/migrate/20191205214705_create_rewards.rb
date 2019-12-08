class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.text :name, null: false
      t.belongs_to :question, null: false, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
