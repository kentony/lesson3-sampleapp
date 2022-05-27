require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
    #↑にリファクタリング
    #@micropost = Micropost.new(content: "Lorem ipsum",
    #                           user_id: @user.id)
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    #content に "    " を入れる
    @micropost.content = "    "
    #その場合のvalid? はnot　 つまりvalidatesでfalse　を想定挙動にする　
    #"    "空文字なので、nilではない。が、presence:false 
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    # a  を141字。
    @micropost.content = "a" * 141
    #その場合のvalid? はnot　つまりvalidatesでfalse　を想定挙動にする
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
