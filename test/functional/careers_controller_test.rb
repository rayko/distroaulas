require 'test_helper'

class CareersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Career.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Career.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Career.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to career_url(assigns(:career))
  end

  def test_edit
    get :edit, :id => Career.first
    assert_template 'edit'
  end

  def test_update_invalid
    Career.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Career.first
    assert_template 'edit'
  end

  def test_update_valid
    Career.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Career.first
    assert_redirected_to career_url(assigns(:career))
  end

  def test_destroy
    career = Career.first
    delete :destroy, :id => career
    assert_redirected_to careers_url
    assert !Career.exists?(career.id)
  end
end
