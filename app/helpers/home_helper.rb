module HomeHelper
  # find answer from paths
  def find_root_lca_depth_from_paths(a, b)
    a_path = a.split('.')
    b_path = b.split('.')
    if a_path[0] != b_path[0]
      return {'root' => 'null', 'lca' => 'null', 'depth' => 'null'}
    else
      for i in (a_path.length - 1).downto(0) do
        for j in (b_path.length - 1).downto(0) do
          if a_path[i] == b_path[j]
            return {'root' => a_path[0], 'lca' => a_path[i], 'depth' => i + 1}
          end
        end
      end
    end
  end

  # utility function to update the paths of nodes
  def update_paths(nodes)
    child_hash = {}
    nodes.each do |node|
      child_hash[node.id] = node.parent_id
    end
    nodes.each do |node|
      if !node.path
        path = find_root_path(node.id, child_hash, [])
        node.path = path.reverse.join('.')
        saved = node.save!
        puts saved
        puts " path: " + node.path
      end
    end
  end

  # return the solution using a hash instead of rail's inbuilt associations
  def find_root_path(value, child_hash, path)
    if !child_hash[value] || path.include?(child_hash[value])
      return path
    end
    path << child_hash[value]
    find_root_path(child_hash[value], child_hash, path)
  end

end
