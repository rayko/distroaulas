require 'test_helper'

class SpacesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Space.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Space.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Space.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to space_url(assigns(:space))
  end

  def test_edit
    get :edit, :id => Space.first
    assert_template 'edit'
  end

  def test_update_invalid
    Space.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Space.first
    assert_template 'edit'
  end

  def test_update_valid
    Space.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Space.first
    assert_redirected_to space_url(assigns(:space))
  end

  def test_destroy
    space = Space.first
    delete :destroy, :id => space
    assert_redirected_to spaces_url
    assert !Space.exists?(space.id)
  end
end
