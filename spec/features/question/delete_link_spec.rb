require 'rails_helper'

feature 'User can delete links attached to their question', %q{
  In order to delete existing links
  As an authenticated user
  I'd like to be able to delete links already attached to my question
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }
  given!(:another_link) { create(:link, :gist, linkable: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'removes several links from an answer' do
      page.find(class: 'question-link', text: link.name).click_on 'Remove link'
      page.find(class: 'question-link', text: another_link.name).click_on 'Remove link'

      expect(page).to_not have_content link.name
      expect(page).to_not have_content another_link.name
    end

    scenario "tries to delete a file from other user's answer" do
      click_on 'Sign out'
      sign_in(other_user)
      visit question_path(question)

      expect(page.find(class: 'question-links', text: link.name)).to_not have_link 'Remove link'
    end
  end

  scenario 'Unauthenticated user tries to delete a file attached to question' do
    visit question_path(question)

    expect(page.find('.question-links')).to_not have_link 'Remove link'
  end
end