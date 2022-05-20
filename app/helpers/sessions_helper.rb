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

    #渡されたユーザがcurrent_userならtrueを返す
    def current_user?(user)
        user && user == current_user
        #nil guard
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

    # 記憶したURL（もしくはデフォルト値）にリダイレクト
    def redirect_back_or(default)
        #forwardingURL があればそちらにredirect。そうでないならdefaultにredirect。(or文)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end    

    # アクセスしようとしたURLを覚えておく
    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end

end
