class AddAdminToUsers < ActiveRecord::Migration[6.0]
  def change
    #何も指定しないとdefaultはnilだが、ここでdefault: falseに倒しておく
    add_column :users, :admin, :boolean, default: false
  end
end
