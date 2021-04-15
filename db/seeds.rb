# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
require 'csv'

# returns the path of root to the given node
  def find_path(value, child_hash, path)
    if !child_hash[value] || path.include?(child_hash[value]) || child_hash[value] == 0
      return path
    end
    path << child_hash[value]
    find_path(child_hash[value], child_hash, path)
    return path
  end

child_hash = {}
csv_text = File.read("#{Rails.root}/lib/nodes.csv")
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
nodes = []

csv.each do |row|
  child_hash[row['id'].to_i] = row['parent_id'].to_i
  n = Node.new
  n.id = row['id']
  n.parent_id = row['parent_id']
  nodes << n
end

# save the path for ltree
nodes.each do |node|
  path = find_path(node.id, child_hash, [])
  node.path = path.reverse.join('.')
  node.save
end