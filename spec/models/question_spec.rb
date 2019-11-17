require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_db_column :title }
  it { should have_db_column :body }
  it { should have_many(:answers).dependent(:nullify) }
end
