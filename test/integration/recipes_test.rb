require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @chef = Chef.create!(chefname: "Olivia", email: "olivia@gmail.com")
    @recipe = Recipe.create(name:"Spaghetti and Meatballs", description: "Great Italian classic. Ready in minutes.", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "Mac and Cheese", description: "Mac and cheese with smoked chicken.  It's bacon dance good!")
    @recipe2.save
  end  

  test 'should get recipes index' do
    get recipes_url
    assert_response :success
  end

  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_match @recipe.name, response.body
    assert_match @recipe2.name, response.body
  end
  
end
