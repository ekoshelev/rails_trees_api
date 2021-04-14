class HomeController < ActionController::API
  def common_ancestor
    # retrieve params from url
    a = params['a'].to_i
    b = params['b'].to_i

    # retrieve initial nodes from DB
    nodes = Node.where("id = #{a} OR id = #{b}")

    # for more efficient queries, note the gem closuretree: https://github.com/ClosureTree/closure_tree
    # note the gem ancestry: https://github.com/stefankroes/ancestry
    # also note ltree: https://www.postgresql.org/docs/9.1/ltree.html
    # TODO: will try to implement ltree before the interview
    if a != b && (nodes[0] == nil || nodes[1] == nil)
      render :json => {'error' => 'those nodes do not exist, please put a valid id'}
    else
      if a == b
        answer = helpers.find_height_root_lca(nodes[0], nodes[0])
      else
        answer = helpers.find_height_root_lca(nodes[0], nodes[1])
      end

      # solution using a hash, O(N) time to pull rows
      # O(1) time to select instead of rails doing a select for each parent.
      # useful if we want to preprocess data & cache
      # nodes = Node.all
      # answer = helpers.find_solution_with_hash(a,b,nodes)
      render :json => answer
    end
  end

  def birds
    # retrieve params from url
    a = params['a'].to_i

    # retrieve initial nodes from DB
    node = Node.where(id: a).includes(:birds)

    # retrieve children from DB, traditional rails way
    # we run into N+1 problem
    answer = retrieve_children(node[0], [])
    render :json => answer
  end

  def retrieve_children(node, array)
    if !node
      return
    end
    bird_name = ''
    node.birds.each{|bird|
      if bird.name
        bird_name += bird.name
      end
    }
    
    array << [node.id, bird_name]
    node.children.each do |child|
      retrieve_children(child, array)
    end
    array
  end
end


