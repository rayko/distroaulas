require 'test_helper'

class SpaceTypesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => SpaceType.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    SpaceType.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    SpaceType.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to space_type_url(assigns(:space_type))
  end

  def test_edit
    get :edit, :id => SpaceType.first
    assert_template 'edit'
  end

  def test_update_invalid
    SpaceType.any_instance.stubs(:valid?).returns(false)
    put :update, :id => SpaceType.first
    assert_template 'edit'
  end

  def test_update_valid
    SpaceType.any_instance.stubs(:valid?).returns(true)
    put :update, :id => SpaceType.first
    assert_redirected_to space_type_url(assigns(:space_type))
  end

  def test_destroy
    space_type = SpaceType.first
    delete :destroy, :id => space_type
    assert_redirected_to space_types_url
    assert !SpaceType.exists?(space_type.id)
  end
end
