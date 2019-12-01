require 'rails_helper'

feature 'User can delete files attached to their answer', %q{
  In order to delete existing attachments
  As an authenticated user
  I'd like to be able to delete files already attached to my answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given(:other_user) { create(:user) }
  given!(:answer_unauthored) { create(:answer, user: other_user, question: question) }

  describe 'Authenticated user', js: true do
    scenario 'removes a file from an answer' do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'this is an answer'
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Answer'

      page.find(class: 'answer-files', text: 'rails_helper.rb').click_on 'Remove file'
      expect(page).to_not have_content 'rails_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to delete a file attached to question' do
    visit question_path(question)

    expect(page).to_not have_link 'Remove file'
  end
end