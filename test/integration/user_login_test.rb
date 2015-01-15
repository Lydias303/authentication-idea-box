require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  def setup
    @user = User.create(username: "name", password: "password")
    visit root_url
  end

  # test user can see login form on root page"

  test 'a user can login' do
    fill_in "session[username]", with: "name"
    fill_in "session[password]", with: "password"
    click_link_or_button "Login"
    within('#banner') do
      assert page.has_content?("Welcome name")
    end
  end

  test 'a user cannot can login' do
   click_link_or_button "Login"
   within('#flash_errors') do
     assert page.has_content?("Invalid")
   end
  end

  test 'it has a user has associated ideas' do
    @idea = Idea.create(title: "idea", description: "description", user_id: user.id)
      ApplicationController.any_instance.stubs(:current_user).returns(user)
      visit user_path(user)
      within('#ideas') do
        assert page.has_content?("description")
        assert page.has_content?("idea")
      end
    end


  test 'a registered user can logout' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    click_link_or_button "Logout"
    within('#flash_notice') do
      assert page.has_content?("Logged out")
    end
  end
end
