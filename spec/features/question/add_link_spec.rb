require 'rails_helper'

feature 'User can add links to a question', %q{
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/jacksonfdam/3000275' }

  scenario 'User adds several links while asking a question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'Add link'

    within page.all('.nested-fields')[0] do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    within page.all('.nested-fields')[1] do
      fill_in 'Link name', with: 'Another gist'
      fill_in 'Url', with: gist_url
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'Another gist', href: gist_url
  end
end