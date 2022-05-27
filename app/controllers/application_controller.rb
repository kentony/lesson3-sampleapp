class ApplicationController < ActionController::Base
    include SessionsHelper

    private
      #users_controllerにあり、またmicroposts_controllerで使う
      #なのでapplication_controllerで書いて共有部品にしてしまう
      def logged_in_user
        unless logged_in?
            #ログインしている時にbeforeフィルターに引っかかってしまう場合、どこにアクセスしたかったかをstoreに控えておく
            store_location
            flash[:danger] = "Please Login"
            redirect_to login_url
        end
      end
end
