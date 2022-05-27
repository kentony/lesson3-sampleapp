class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    #beforeフィルタでlogged_inが前提
    #buildでuser_idに紐づけてインスタンス作成
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      #失敗したらhomeのフォームに返す
      #ログインしてない場合はhomeに戻すというよくあるやつ
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      #  @micropost = current_user.microposts.build(micropost_params)
      # で既に関連付けて実装しているので、user_editは不要
      params.require(:micropost).permit(:content, :image)
    end

    def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
    end
end
