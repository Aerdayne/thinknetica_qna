require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :file }
  it { should belong_to(:question) }
end
