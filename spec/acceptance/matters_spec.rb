# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Admin' do
  background do
    @admin = FactoryGirl.create :admin
    login_user @admin
  end

  scenario 'creates a new matter' do
    @career = FactoryGirl.create :career

    visit root_path
    click_link 'Materias'
    click_link 'Nueva Materia'

    within '#new_matter' do
      select @career.name, :from => 'matter_career_id'
      fill_in 'matter_name', :with => 'Matter Test'
      fill_in 'matter_short_name', :with => 'MT'
      fill_in 'matter_year', :with => '1'
      fill_in 'matter_responsible', :with => 'Lolcat'
      click_button 'Guardar'
    end

    page.should have_content 'La materia se ha creado correctamente.'
    page.should have_content 'Materia'
    page.should have_content 'Nombre: Matter Test'
    page.should have_content 'Nombre corto: MT'
    page.should have_content "Carrera: #{@career.name}"
    page.should have_content "Plan: #{@career.plan.name}"
    page.should have_content 'Año: 1'
    page.should have_content 'No hay eventos aun.'
  end

  scenario 'modifies a matter' do
    @matter = FactoryGirl.create :matter

    visit root_path
    click_link 'Materias'
    page.should have_content @matter.name
    page.should have_content 'Ver'
    page.should have_content 'Editar'
    page.should have_content 'Eliminar'
    click_link 'Editar'
    page.should have_content 'Editar Materia'
    fill_in 'matter_name', :with => 'Matter Lol'
    fill_in 'matter_short_name', :with => 'LOL'
    fill_in 'matter_year', :with => '5'
    fill_in 'matter_responsible', :with => 'Madcat'
    click_button 'Guardar'
    page.should have_content 'Materia'
    page.should have_content 'Nombre: Matter Lol'
    page.should have_content 'Nombre corto: LOL'
    page.should have_content 'Año: 5'
  end

  scenario 'deletes a matter', :js => true do
    @matter = FactoryGirl.create :matter

    visit root_path

    display_element '#edu_menu'
    click_link 'Materias'
    page.should have_content @matter.name
    page.should have_content 'Ver'
    page.should have_content 'Editar'
    page.should have_content 'Eliminar'
    click_link 'Eliminar'

    confirm_popup

    page.should have_content 'La materia se elimino correctamente.'
    page.should_not have_content @matter.name

  end
end
