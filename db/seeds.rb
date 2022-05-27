# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",
    email: "example@railstutorial.org",
    password:              "foobar",
    password_confirmation: "foobar",
    admin: true)

# 追加のユーザーをまとめて生成する
99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(name:  name,
      email: email,
      password:              password,
      password_confirmation: password)
end

# ユーザーの一部を対象にマイクロポストを生成する
#↓上から(古いものから)Userを5つtakeする
users = User.order(:created_at).take(6)
#上記に対し、以下内容を50回渡す
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end