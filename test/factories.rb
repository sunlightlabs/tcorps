require 'factory_girl'

Factory.define :organization do |o|
  o.name 'Organization Name'
end

Factory.define :task do |t|
  t.association :user
  t.association :campaign
  t.key {Factory.next :task_key}
end
Factory.sequence(:task_key) {|i| "task_key_#{i}"}

Factory.define :completed_task, :parent => :task do |t|
  t.completed_at {Time.now}
end

Factory.define :campaign do |c|
  c.association :organization
  c.name 'Campaign Name'
  c.keyword {Factory.next :campaign_keyword}
  c.url {|a| "http://example.com/#{a.keyword}"}
  c.instructions 'Instructions'
  c.description 'Public description'
  c.private_description 'Private description'
  c.points 5
end
Factory.sequence(:campaign_keyword) {|i| "campaign#{i}"}

Factory.define :user do |u|
  u.login {Factory.next :user_login}
  u.email {Factory.next :user_email}
  u.password 'test'
  u.password_confirmation 'test'
end
Factory.sequence(:user_login) {|i| "user#{i}"}
Factory.sequence(:user_email) {|i| "user#{i}@example.com"}

Factory.define :manager, :parent => :user do |u|
  u.association :organization
end

Factory.define :admin, :parent => :user do |u|
  u.admin true
end