# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

client = Slack::Client.instance

users = client.users_list.with_indifferent_access

users[:members].map(&:with_indifferent_access).select do |member|
  !member[:is_bot] && member[:id].downcase != 'uslackbot'
end.each do |member|
  User.find_or_create_by(name: member[:real_name].strip, slack_handle: member[:name], slack_id: member[:id])
end
