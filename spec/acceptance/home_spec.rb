require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Home", %q{
  In order to show the correct links
  As a no logged user
  I want to see the page
} do

  scenario "The home should content SignUp and LogIn" do
    visit root_path

    page.should have_content "Ingresar"
  end
end
