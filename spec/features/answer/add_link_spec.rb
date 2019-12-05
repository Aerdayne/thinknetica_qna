require 'rails_helper'

feature 'User can add links to an answer', %q{
  In order to provide additional info to my answer
  As a question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) {'https://gist.github.com/jacksonfdam/3000275'}

  scenario 'User adds several links while giving an answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answer-new' do
      click_on 'Add link'

      fill_in 'Body', with: 'My answer'

      within all('.nested-fields')[0] do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end

      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'Another gist'
        fill_in 'Url', with: gist_url
      end

      click_on 'Answer'
    end

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'Another gist', href: gist_url
    end
  end

end