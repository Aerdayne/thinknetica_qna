require 'rails_helper'

feature 'User can edit their own answer', %q{
  In order to edit my answer
  As an authenticated user
  I'd like ot be able to edit my own answer
} do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:unauthered_answer) { create(:answer, question: question, user: other_user) }

  scenario 'Unauthenticated can not edit answers' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'edits their own answer' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits their own answer with errors' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      expect(page).to have_content answer.body
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer" do
      expect(page.find(class: 'answer', text: unauthered_answer.body)).to_not have_link 'Edit'
    end

    scenario 'edits their answer and attaches several files' do
      page.find(".answer[data-id='#{answer.id}']").click_on 'Edit'
      within '.answers' do
        attach_file 'Attach files:', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edits their answer and attaches several links' do
      page.find(".answer[data-id='#{answer.id}']").click_on 'Edit'

      within '.answers' do
        click_on 'Add link'
        click_on 'Add link'

        within all('.nested-fields')[0] do
          fill_in 'Link name', with: 'attached link'
          fill_in 'Url', with: 'https://google.com'
        end

        within all('.nested-fields')[1] do
          fill_in 'Link name', with: 'another attached link'
          fill_in 'Url', with: 'https://google.com'
        end

        click_on 'Save'
      end

      expect(page).to have_link 'attached link'
      expect(page).to have_link 'another attached link'
    end
  end
end