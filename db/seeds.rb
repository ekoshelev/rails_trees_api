# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

csv_text = File.read('C:\Users\lizko\code\rails\dataplor_interview\lib\nodes.csv')
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
# csv.each do |row|
#   n = Node.new
#   n.id = row['id']
#   n.parent_id = row['parent_id']
#   n.save
# end

child_hash = {}

csv.each do |row|
  child_hash[row['id']] = row['parent_id']
end

nodes = Node.all
nodes.each do |node|
  path = helpers.hash_solution_find_path(node.id, child_hash, [])
  node.path = path.join('.')
  puts path
  node.save
end


