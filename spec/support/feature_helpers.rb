module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def attach_files(other_user, question)
    sign_in(other_user)
    visit question_path(question)
    fill_in 'Body', with: 'this is an answer'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Answer'
    click_on 'Sign out'
  end
end