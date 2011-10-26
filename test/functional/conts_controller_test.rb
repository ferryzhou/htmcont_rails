require 'test_helper'

class ContsControllerTest < ActionController::TestCase
  setup do
    @cont = conts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cont" do
    assert_difference('Cont.count') do
      post :create, cont: @cont.attributes
    end

    assert_redirected_to cont_path(assigns(:cont))
  end

  test "should show cont" do
    get :show, id: @cont.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cont.to_param
    assert_response :success
  end

  test "should update cont" do
    put :update, id: @cont.to_param, cont: @cont.attributes
    assert_redirected_to cont_path(assigns(:cont))
  end

  test "should destroy cont" do
    assert_difference('Cont.count', -1) do
      delete :destroy, id: @cont.to_param
    end

    assert_redirected_to conts_path
  end
end
