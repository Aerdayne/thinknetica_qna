require 'rails_helper'

feature 'User can answer a question', %q{
  In order to give an answer to an existing question
  As an authenticated user
  I'd like to be able to answer a question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers a question' do
      fill_in 'Body', with: 'this is an answer'
      click_on 'Answer'

      expect(page).to have_content 'Your answer has been successfully created.'
      expect(page).to have_content 'this is an answer'
    end

    scenario 'answers with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers a question with several files attached' do
      fill_in 'Body', with: 'this is an answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'Multiple sessions', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        fill_in 'Body', with: 'This is an answer'
        click_on 'Answer'
        expect(page).to have_content 'This is an answer'
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        expect(page).to have_content 'This is an answer'
      end
    end
  end
end