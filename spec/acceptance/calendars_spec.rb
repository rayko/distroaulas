require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'Admin' do
  background do
    @admin = FactoryGirl.create :admin
    login_user @admin
  end

  scenario 'creates a calendar without career' do
    visit root_path
    click_link 'Calendarios'
    click_link 'Nuevo Calendario'
    within '#new_calendar' do
      fill_in 'calendar_name', :with => 'Calendar Test'
      click_button 'Guardar'
    end
    page.should have_content 'El calendario se creo correctamente.'
    page.should have_content 'Calendar Test'
    page.should have_content 'WeeklyCalendar'
    page.should have_content 'Semana anterior'
    page.should have_content 'Semana actual'
    page.should have_content 'Semana siguiente'
  end

  scenario 'creates a calendar with a career' do
    @career = FactoryGirl.create :career

    visit root_path
    click_link 'Calendarios'
    click_link 'Nuevo Calendario'
    within '#new_calendar' do
      select @career.name, :from => 'calendar_career_id'
      fill_in 'calendar_name', :with => 'Calendar Test'
      click_button 'Guardar'
    end
    page.should have_content 'El calendario se creo correctamente.'
    page.should have_content 'Calendar Test'
    page.should have_content 'WeeklyCalendar'
    page.should have_content 'Semana anterior'
    page.should have_content 'Semana actual'
    page.should have_content 'Semana siguiente'
  end

  scenario 'modifies a calendar' do
    @calendar = FactoryGirl.create :calendar

    visit root_path
    click_link 'Calendarios'
    page.should have_content @calendar.name
    page.should have_content 'Ver'
    page.should have_content 'Editar'
    page.should have_content 'Eliminar'
    click_link 'Editar'
    fill_in 'calendar_name', :with => 'LolCal'
    click_button 'Guardar'
    page.should have_content 'El calendario se actualizo correctamente.'
    page.should have_content 'LolCal'
  end

  scenario 'deletes a calendar', :js => true do
    @calendar = FactoryGirl.create :calendar
    visit root_path
    display_element '#misc_menu'
    click_link 'Calendarios'
    page.should have_content @calendar.name
    page.should have_content 'Ver'
    page.should have_content 'Editar'
    page.should have_content 'Eliminar'
    click_link 'Eliminar'
    confirm_popup
    page.should have_content "El calendario se ha eliminado correctamente."
    page.should_not have_content @calendar.name
  end
end
