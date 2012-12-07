require 'spec_helper'

describe 'the authentication process' do
  let(:email) { "user@domain.com" }
  let(:password) { "somePass0rd" }

  it "signs me in" do
    FactoryGirl.create :user, :email => email, :password => password
    visit login_path
    within '#session' do
      fill_in 'user_name_or_email', :with => email
      fill_in 'Password', :with => password
      click_on 'Sign In'
    end
    page.should have_content 'You are now logged in.'
  end

  it "signs me out" do
    login_user
    click_on 'Sign Out'
    page.should have_content 'You are now logged out.'
  end
end
