require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "successful edit with friendly forwarding" do
    #GET edit page
    get edit_user_path(@user)
    #loginを促す
    log_in_as(@user)
    #login 完了したら、editpageに返ってくる
    assert_redirected_to edit_user_url(@user)
    tmpname = "Foo Bar"
    tmpemail = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  tmpname,
                                              email: tmpemail,
                                              #password入力なし=>passwordは変更しない
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    #assert_equal 期待する値, 実際の値
    assert_equal tmpname, @user.name
    assert_equal tmpemail, @user.email

  end

  test "unsuccessful edit" do
    log_in_as(@user)
    # GET /user/{:id}
    get edit_user_path(@user)
    assert_template 'users/edit'
    #editがダメなパターンを入れる。validate引っかかるような値をセット。
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select "div.alert", "The form contains 4 errors."
  end

end

