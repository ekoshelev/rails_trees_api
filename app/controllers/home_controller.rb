class HomeController < ActionController::API
  # common ancestor endpoint
  # for more efficient queries, note the gem closuretree: https://github.com/ClosureTree/closure_tree
  # note the gem ancestry: https://github.com/stefankroes/ancestry
  # for this project we use ltree: https://www.postgresql.org/docs/9.1/ltree.html
  def common_ancestor
    # retrieve params from url
    a = params['a'].to_i
    b = params['b'].to_i

    # retrieve initial nodes from DB
    nodes = Node.where("id = #{a} OR id = #{b}")

    # check to make sure both nodes exist
    if a != b && (nodes[0] == nil || nodes[1] == nil)
      render :json => {'error' => 'those nodes do not exist, please put a valid id'}
    else

      # edge case if the same node is given, return self
      if nodes[0].id == nodes[1].id
        answer = {'root' => nodes[0].path[0], 'lca' => nodes[0].id, 'depth' => nodes[0].path.length}
      else
        # use helper function to return data from node paths
        answer = helpers.find_root_lca_depth_from_paths(nodes[0].path, nodes[1].path)
      end

      # render solution
      render :json => answer
    end
  end

  # birds endpoint
  def birds
    # retrieve params from url
    a = params['a'].to_i

    # retrieve initial node from DB
    node = Node.where("id = #{a}").includes(:birds)

    # check to make sure the node exists
    if node[0] == nil
      render :json => {'error' => 'that node does not exist, please put a valid id'}
    else

      # retrieve subtrees using ltree
      # use includes instead of join for more efficient query
      children = Node.where("path ~ '#{node[0].path}.*{,}'").includes(:birds)

      # also include the parent node
      children.merge(node)

      # return an array of ids and related bird names
      answer = []
      children.each do |child|
        answer << [child.id, child.birds.map{|bird| bird.name}.join(' ')]
      end

      # render solution
      render :json => answer
    end
    end

  # utility endpoint to update paths for ltree
  def update_paths
    nodes = Node.all
    helpers.update_paths(nodes)
    render :json => {'result' => 'updated paths was called'}
  end
end


