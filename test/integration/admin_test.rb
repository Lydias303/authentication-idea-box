require 'test_helper'

class AdminTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  test 'an admin user can login' do
    admin_user = User.create(username: "protected", password: "password", password_confirmation: "password", role: "admin")
    visit root_url
    fill_in "session[username]", with: "protected"
    fill_in "session[password]", with: "password"
    click_link_or_button "Login"
    click_link_or_button "Admin"
    within("#admin") do
      assert page.has_content?("Hi Admin")
    end
  end

  test 'only an admin user can view to admin page' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_path
    within ('#flash_alert') do
      assert page.has_content?("not authorized")
    end
  end

  test 'an admin can create new categories' do
    admin_user = User.create(username: "protected", password: "password", password_confirmation: "password", role: "admin")
    ApplicationController.any_instance.stubs(:current_user).returns(admin_user)
    visit admin_path
    fill_in "category_name", with: "cool"
    click_link_or_button "Add Category"
    within("#category_list") do
      assert page.has_content?("cool")
    end
  end


  test 'an admin can delete categories' do
    admin_user = User.create(username: "protected", password: "password", password_confirmation: "password", role: "admin")
    category = Category.create(name: "blah")
    ApplicationController.any_instance.stubs(:current_user).returns(admin_user)
    visit admin_path
      assert 1, Category.all.count
    within("#category_list") do
      click_link_or_button "Delete"
    end
      assert 0, Category.all.count
  end

  test 'a logged in admin can edit their category' do
    admin_user = User.create(username: "protected", password: "password", password_confirmation: "password", role: "admin")
    ApplicationController.any_instance.stubs(:current_user).returns(admin_user)
    Category.create(name: 'old')
    visit admin_path
    within("#category_list") do
      assert page.has_content?("old")
    end
    click_link_or_button 'Edit'
    fill_in "category_name", with: "new"
    click_link_or_button "Update"
    within('#category_list') do
      assert page.has_content?("new")
    end
  end

  test ' a logged in admin can create an image' do
    admin_user = User.create(username: "protected", password: "password", password_confirmation: "password", role: "admin")
    ApplicationController.any_instance.stubs(:current_user).returns(admin_user)
    Image.create(title: "title" img: "url")
    visit admin_path
    within("#images") do
      assert page.has_content?("title")
    end
  end
end
