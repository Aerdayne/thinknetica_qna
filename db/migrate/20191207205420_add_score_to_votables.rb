class AddScoreToVotables < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :score, :integer
    add_index :answers, :score

    add_column :questions, :score, :integer
    add_index :questions, :score

    change_column_default :answers, :score, 0
    change_column_default :questions, :score, 0

    change_column_null :answers, :score, false
    change_column_null :questions, :score, false
  end
end
