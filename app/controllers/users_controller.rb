class UsersController < ApplicationController
  #:logged_in_userを呼び出す　[:edit, :update]メソッドが呼び出されたら。
  #メソッド名を引数にするときはシンボルを使う
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  #:correct_userを呼び出す　[:edit, :update]メソッドが呼び出されたら。
  before_action :correct_user,   only: [:edit, :update]
  #:logged_in_user と :correct_user のbeforeフィルタが併存している理由
  #:logged_in_userではログイン自体の確認
  #current_userはログイン中のユーザが正しいことの確認(logged_in_userが前提.故にlogged_in_userより後方に配置)
  #お互いに責務が違う。
  before_action :admin_user,     only: :destroy
  
  def index
    #@users = User.all
    @users = User.paginate(page: params[:page])
  end
  
  #GET /users/:id
  def show
    @user = User.find(params[:id])
  end
  
  #GET /users/new
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      #サインアップしたらついでにlog_in する
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      #redirect_toとは
      # GET "/users.#{@user.id}"  
      #に対しGETリクエストを飛ばすということ
      #詳細に分解すると
      #redirect_to user_path(@user)
      #-> redirect_to user_path(@user.id)
          #-> redirect_to user_path(1)
             #->              /users/1
             #となる 
    else
      render 'new'
      #失敗した場合、もう一度newテンプレートに遷移する
    end
  end


  # GET /users/:id/edit に対し、edit用のフォームを提供するメソッド。PATCHに対応するものではない。
  def edit
    @user = User.find(params[:id])
    # => app/views/users/edit.html.erb
  end

  # PATCH /users/:id
  #PATCHメソッドに対応するのはこっち
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "Update Done"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User Destroyed!!!"
    redirect_to users_url
  end


  private

    def user_params
      #admin属性はpermitされていない。なぜ？
      #-> PATCH /users/17?admin=1  
      # とかの投入でAdmin権限取られる対策
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    #以下のメソッド呼び出し前にbeforeフィルター入る

    def logged_in_user
      unless logged_in?
        #ログインしている時にbeforeフィルターに引っかかってしまう場合、どこにアクセスしたかったかをstoreに控えておく
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      # 今ログイン中のcurrent_userは、@userですか（つまり本人ですか）。そうでないなら(unless)root_urlへ 
      redirect_to(root_url) unless @user == current_user
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
