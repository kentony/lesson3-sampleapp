module SessionsHelper
    #ログインするメソッド
    def log_in(user)
        session[:user_id] = user.id
    end
    
    #ログイン中のユーザを定義するメソッド
    #@current_user
    #インスタンス変数利用の理由：view等いろんな番所でこの処理を使いたいから
    #↓current_user＝現在セッション中ユーザとして定義し、それが存在しないならnilを返したい(存在しな変数にはnilが返るというRailsの性質)。
    #if @current_user.nil?
    #  @current_user = User.find_by(id: session[:user_id])
    #else
    #  @current_user
    #end
    #上記は下記のように書ける。8.2.2.参照
    def current_user
        if session[:user_id]
          @current_user ||= User.find_by(id: session[:user_id])
          # a = a +1 を a += 1 と書くのと同じ
          #  a||= => a = a || User.find_by... の意味
        end
    end

    #ログイン中ならtrue, そうれないならfalse
    def logged_in?
        #current_user が nil? 「では無い」
        !current_user.nil?
    end

    def log_out
        session.delete(:user_id)
        @current_user = nil
    end 
end
