require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Olivia", email: "olivia@gmail.com",
                        password: "password", password_confirmation: "password")
  end

  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: '', email: ''}}
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: 'Maya', email: 'maya-dog@doggone.com'}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Maya", @chef.chefname
    assert_match "maya-dog@doggone.com", @chef.email 
  end
end
