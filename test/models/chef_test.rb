require 'test_helper'

class ChefTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.new(chefname: "Olivia", email: "olivia@example.com",
                    password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @chef.valid?
  end

  test "name should be present" do
    @chef.chefname = ""
    assert_not @chef.valid?
  end

  test "name should be less than 30 characters" do
    @chef.chefname = "Olivia" * 6
    assert_not @chef.valid?
  end

  test "email should be present" do
    @chef.email = ""
    assert_not @chef.valid?
  end

  test "email should not be more than 255 characters" do
    @chef.email = "olivia@example.com" * 20
    assert_not @chef.valid?
  end

  test "email should accept correct format" do
    valid_emails = %w[user@example.com OLIVIA@gmail.com J.Hall@example.ca jessica+hall@co.uk.org]
    valid_emails.each do |v|
      @chef.email = v
      assert @chef.valid?, "#{v.inspect} should be valid."
    end
  end
  
  test "should reject invalid addresses" do
    invalid_emails = %w[olivia@example olivia@example,com olivia.hall@gmail. jessica@bar+foo.com]
    invalid_emails.each do |invalid|
      @chef.email = invalid
      assert_not @chef.valid?, "#{invalid.inspect} should be invalid."
    end
  end

  test "email should be unique and case insensitive" do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test "email should be lower case before hitting DB" do
    mixed_email = "JessicaHall@Example.Com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end

  test "password should be present" do
    @chef.password = @chef.password_confirmation = ''
    assert_not @chef.valid?
  end

  test "password should be at least 5 characters" do
    @chef.password = @chef.password_confirmation = "O" * 4
    assert_not @chef.valid?
  end

  test "associated recipes should be destroyed" do
    @chef.save
    @chef.recipes.create!(name: "testing destroy", description: "testing destroy function")
    assert_difference 'Recipe.count', -1 do
      @chef.destroy
    end
  end

end
