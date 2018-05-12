require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Olivia", email: "olivia@gmail.com",
                         password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "Jessica", email: "jess@gmail.com",
                          password: "password2", password_confirmation: "password2")
    @admin = Chef.create!(chefname: "Jeff", email: "jeff@example.com",
                        password: "password", password_confirmation: "password", admin: true)
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

  test "accept edit attempt by admin user" do
    sign_in_as(@admin, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: 'Maya2', email: 'maya-dog2@doggone.com'}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Maya2", @chef.chefname
    assert_match "maya-dog2@doggone.com", @chef.email 
  end

  test "redirect edit attempt by another non-admin user" do
    sign_in_as(@chef2, "password2")
    patch chef_path(@chef), params: { chef: { chefname: 'Maya3', email: 'maya-dog3@doggone.com'}}
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "Olivia", @chef.chefname
    assert_match "olivia@gmail.com", @chef.email
  end
  
end
