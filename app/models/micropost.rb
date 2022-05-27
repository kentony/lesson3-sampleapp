class Micropost < ApplicationRecord
  belongs_to :user
  #                  ↓{}procオブジェクト。{}のコマンドの中身を引数として渡す。
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
