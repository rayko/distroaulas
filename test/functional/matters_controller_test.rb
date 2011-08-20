require 'test_helper'

class MattersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Matter.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Matter.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Matter.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to matter_url(assigns(:matter))
  end

  def test_edit
    get :edit, :id => Matter.first
    assert_template 'edit'
  end

  def test_update_invalid
    Matter.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Matter.first
    assert_template 'edit'
  end

  def test_update_valid
    Matter.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Matter.first
    assert_redirected_to matter_url(assigns(:matter))
  end

  def test_destroy
    matter = Matter.first
    delete :destroy, :id => matter
    assert_redirected_to matters_url
    assert !Matter.exists?(matter.id)
  end
end
