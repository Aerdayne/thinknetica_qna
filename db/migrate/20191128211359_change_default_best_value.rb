class ChangeDefaultBestValue < ActiveRecord::Migration[6.0]
  def change
    change_column_null :answers, :best, false
    change_column_default :answers, :best, false
  end
end
