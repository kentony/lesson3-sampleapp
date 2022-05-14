require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end  
  
  #invalid = 間違った状態のテスト
  test "login with valid email/invalid password" do
    get login_path
    #login_pathに行く
    assert_template 'sessions/new'
    #newテンプレートが呼び出される
    post login_path, params: { session: { email:    @user.email,
                                          password: "invalid" } }
    # email は正しいが、passwordは間違っている場合のテスト
    assert_not is_logged_in?
    assert_template 'sessions/new'
    #newテンプレートにrenderされる（戻ってくる）
    assert_not flash.empty?
    #flashがempty「ではない」ことを期待する 
    get root_path
    #root_path行く
    assert flash.empty?
    #flashがemptyであることを期待する(つまりflashが消えている)
  end

    #valid = 正常挙動のテスト
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    #login_path, logput_path, user_path のリンクがある
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    # logout 後なので、 is_logged_in? はnot だよね？
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end  
    
end