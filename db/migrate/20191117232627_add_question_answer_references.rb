class AddQuestionAnswerReferences < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :question, foreign_key: true

    change_column_null :answers, :body, false
    change_column_null :questions, :title, false
    change_column_null :questions, :body, false
  end
end
