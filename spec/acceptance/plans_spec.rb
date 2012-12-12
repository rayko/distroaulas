require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Admin' do
  background do
    @admin = FactoryGirl.create :admin
    login_user @admin
  end
  scenario 'creates a new plan' do
    visit root_path
    click_link 'Planes'
    click_link 'Nuevo Plan'

    within '#new_plan' do
      fill_in 'plan_name', :with => 'SuperPlan'
      click_button 'Guardar'
    end

    page.should have_content 'El plan se ha creado correctamente.'
    page.should have_content 'Nombre: SuperPlan'
    page.should have_content 'Carreras: 0'
  end

  scenario 'modifies a plan' do
    @plan = FactoryGirl.create :plan

    visit root_path
    click_link 'Planes'
    click_link 'Editar'

    page.should have_content 'Editar Plan'

    fill_in 'plan_name', :with => 'MegaPlan'
    click_button 'Guardar'

    page.should have_content 'El plan se ha actualizado correctamente.'
    page.should have_content 'Nombre: MegaPlan'
  end

  scenario 'eliminates a plan', :js => true do
    @plan = FactoryGirl.create :plan

    visit root_path

    display_element '#edu_menu'
    click_link 'Planes'
    click_link 'Eliminar'

    confirm_popup
    page.should have_content 'El plan se ha eliminado correctamente.'
  end
end
