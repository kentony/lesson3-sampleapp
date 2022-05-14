class SessionsController < ApplicationController
  def new
  end
  
  #/sessions/new.html のPOSTと、routes記述のルーティングによって
  #↓が呼び出される
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    
    #↓ if の条件式にuserを組み込む→userの中身がnilなら自動的にfalseの方に分岐が入る。
    #なので use.nil? と書かなくて良い。
    #if user && user.authenticate(params[:session][:password])  ぼっち演算子で↓のように書き換えられる
    if user&.authenticate(params[:session][:password])
     #Successした場合の処理
      log_in user
      flash[:success] = "Welcome Back!"
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      #login 失敗したらnew にrenderする
      render 'new'
    end
  end

  #DELETEリクエストが　logout_pathに来た時
  def destroy
    log_out
    # とりあえずトップページに飛ばす. root_pathでも良いが慣習的にroot_url
    redirect_to root_url
  end
end
