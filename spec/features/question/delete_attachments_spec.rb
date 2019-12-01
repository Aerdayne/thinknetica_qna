require 'rails_helper'

feature 'User can delete files attached to their question', %q{
  In order to delete existing attachments
  As an authenticated user
  I'd like to be able to delete files already attached to my question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }
  given(:question_unauthored) { create(:question, user: other_user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'removes a file from a question', js: true do
      within '.question' do
        click_on 'Edit'
        attach_file 'Attach files:', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Save'
      end

      page.find(class: 'question', text: question.body).click_on 'Remove file'
      expect(page).to_not have_content 'rails_helper.rb'
    end

    scenario 'tries to remove files from other\'s question', js: true do
      visit question_path(question_unauthored)

      expect(page).to_not have_link 'Mark as best'
    end
  end

  scenario 'Unauthenticated user tries to delete a file attached to question' do
    visit question_path(question)

    expect(page).to_not have_link 'Remove file'
  end
end