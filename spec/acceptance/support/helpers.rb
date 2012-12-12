# -*- coding: utf-8 -*-
module HelperMethods
  # Put helper methods you need to be available in all tests here.

  def login_user user
    visit new_user_session_path

    within '#user_new' do
      fill_in 'user_login', :with => user.email
      fill_in 'user_password', :with => '123456'
      click_button 'Ingresar'
    end
  end

  def display_element element_id
    # Emulates a hover event to make it visible
    page.execute_script('$("' + element_id + '").css("visibility", "visible")')
  end

  def confirm_popup
    page.driver.browser.switch_to.alert.accept
  end

end

RSpec.configuration.include HelperMethods, :type => :acceptance
