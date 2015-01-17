require 'test_helper'

class UserIdeasTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  def setup
    @user = User.create(username: "name", password: "password")
    visit root_url
  end

  test 'a user has associated ideas' do
    category = Category.create(name: 'good_ones')
    @idea = Idea.create(title: "idea", description: "description", user_id: user.id, category_id: category.id)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit user_path(user)
    within('#ideas') do
      assert page.has_content?("description")
      assert page.has_content?("idea")
    end
  end

  test 'a logged in user can create ideas on their page' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    Category.create(name: 'good_ones')
    visit user_path(user)
    fill_in "idea_title", with: "Bad Idea"
    fill_in "idea_description", with: "Such a bad idea"
    select "good_ones", :from => "idea_category_id"
    click_link_or_button "Create"
    within("#ideas") do
      assert page.has_content?("Bad Idea")
      assert page.has_content?("Such a bad idea")
      assert page.has_content?('good_ones')
    end
  end

  test 'a logged in user can edit their ideas' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    cat = Category.create(name: 'category')
    dog = Category.create(name: 'other_category')
    @user.ideas.create(title: "idea", description: "description", category_id: dog.id)
    visit user_path(user)
    click_link_or_button 'Edit'
    fill_in "idea_title", with: "new idea"
    fill_in "idea_description", with: "new description"
    select "category", :from => "idea_category_id"

    click_link_or_button "Update"
    within('#ideas') do
      assert page.has_content?("new idea")
      assert page.has_content?("new description")
      assert page.has_content?("category")
    end
  end

  test 'a logged in user can delete their ideas' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    cat = Category.create(name: 'category')
    @user.ideas.create(title: "idea", description: "description", category_id: cat.id)
    visit user_path(user)
    within('#ideas') do
      assert page.has_content?("idea")
      assert page.has_content?("description")
      assert page.has_content?("category")
    end
    click_link_or_button "Delete"
    within('#ideas') do
      refute page.has_content?("idea")
      refute page.has_content?("description")
      refute page.has_content?("category")
    end
  end
end
