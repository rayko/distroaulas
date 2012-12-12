require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Admin' do
  background do
    @admin = FactoryGirl.create :admin
    login_user @admin
  end

  scenario 'creates a new career' do
    @plan = FactoryGirl.create :plan

    visit root_path
    click_link 'Carreras'
    click_link 'Nueva Carrera'

    within '#new_career' do
      select @plan.name, :from => 'career_plan_id'
      fill_in 'career_name', :with => 'Career Test'
      fill_in 'career_short_name', :with => 'CT'
      click_button 'Guardar'
    end

    page.should have_content 'La carrera se ha creado correctamente.'
    page.should have_content 'Carrera'
    page.should have_content 'Nombre: Career Test'
    page.should have_content 'Nombre corto: CT'
    page.should have_content 'Materias: 0'
  end

  scenario 'modifies a career' do
    @career = FactoryGirl.create :career

    visit root_path
    click_link 'Carreras'
    page.should have_content @career.name
    page.should have_content 'Ver'
    page.should have_content 'Editar'
    page.should have_content 'Eliminar'
    click_link "Editar"
    fill_in 'career_name', :with => 'Lolcat'
    fill_in 'career_short_name', :with => 'LC'
    click_button 'Guardar'
    page.should have_content 'La carrera se ha actualizado correctamente.'
    page.should have_content 'Carrera'
    page.should have_content 'Nombre: Lolcat'
    page.should have_content 'Nombre corto: LC'

  end

  scenario 'deletes a career', :js => true do
    @career = FactoryGirl.create :career

    visit root_path

    display_element '#edu_menu'
    click_link 'Carreras'
    page.should have_content @career.name
    page.should have_content 'Ver'
    page.should have_content 'Editar'
    page.should have_content 'Eliminar'
    click_link 'Eliminar'

    confirm_popup

    page.should have_content 'La carrera se ha eliminado correctamente'
    page.should_not have_content @career.name
  end
end
