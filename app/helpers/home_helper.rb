module HomeHelper
  # return height, root and lca given two nodes
  def find_height_root_lca(a_node, b_node)
    if a_node.id == b_node.id
      a_path = find_root_path(a_node)
      return {'root' => a_path[a_path.length-1], 'lca' => a_node.id, 'depth' => a_path.length + 1}
    else
      a_path = find_root_path(a_node)
      b_path = find_root_path(b_node)
      answer = find_data_from_path(a_path, b_path)
    end
  end

  # returns the path from root to node in an array
  def find_root_path(node)
    path_array = []
    parent = node.parent
    while parent do
      path_array << parent.id
      parent = parent.parent
    end
    path_array
  end

  # given two paths, return the root, lca, and depth of lca
  def find_data_from_path(a_path, b_path)
    if a_path[a_path.length - 1] != b_path[b_path.length - 1]
      return {'root' => 'null', 'lca' => 'null', 'depth' => 'null'}
    else
      for i in 0..a_path.length - 1 do
        for j in 0..b_path.length - 1 do
          if a_path[i] == b_path[j]
            return {'root' => a_path[a_path.length - 1], 'lca' => a_path[i], 'depth' => a_path.length - i}
          end
        end
      end
    end
  end

  # return the solution using a hash instead of rail's inbuilt associations, potentially faster but not space efficient
  def find_solution_with_hash(a,b,nodes)
    child_hash = {}
    nodes.each do |node|
      child_hash[node.id] = node.parent_id
    end
    return hash_solution_find_height_root_and_common_ancestor(a, b, child_hash)
  end

  # return the solution using a hash instead of rail's inbuilt associations
  def hash_solution_find_height_root_and_common_ancestor(a, b, child_hash)
    a_path = hash_solution_find_path(a, child_hash, [])
    b_path = hash_solution_find_path(b, child_hash, [])
    find_answer_from_path(a_path, b_path)
  end

  # return the solution using a hash instead of rail's inbuilt associations
  def hash_solution_find_path(value, child_hash, path)
    if !child_hash[value]
      return path
    end
    path << child_hash[value]
    find_path(child_hash[value], child_hash, path)
  end
end
