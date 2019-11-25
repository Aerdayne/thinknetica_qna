class AddBestFlagToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :best, :boolean
    add_index :answers, %i[question_id best], where: 'best', unique: true
  end
end
