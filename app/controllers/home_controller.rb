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
    # https://github.com/gzigzigzeo/pg_closure_tree_rebuild
    if a != b && (nodes[0] == nil || nodes[1] == nil)
      render :json => {'error' => 'those nodes do not exist, please put a valid id'}
    else

      # solution using ltree:
      if nodes[0].id == nodes[0].id
        answer = {'root' => nodes[0].path[0], 'lca' => nodes[0].id, 'depth' => nodes[0].path.length}
      end
      answer = helpers.find_answer_from_paths(nodes[0], nodes[1])

      # if a == b
      #   answer = helpers.find_height_root_lca(nodes[0], nodes[0])
      # else
      #   answer = helpers.find_height_root_lca(nodes[0], nodes[1])
      # end


      # # solution using a hash, O(N) time to pull rows
      # # O(1) time to select instead of rails doing a select for each parent.
      # # # useful if we want to preprocess data & cache
      # nodes = Node.all
      # answer = helpers.find_solution_with_hash(a,b,nodes)
      render :json => answer
    end
  end

  def birds
    # retrieve params from url
    a = params['a'].to_i

    # retrieve initial nodes from DB
    node = Node.where("id = #{a}").includes(:birds)
    children = Node.where("path ~ '#{node[0].path}.*{,}'").includes(:birds)
    children.merge(node)
    answer = []
    children.each do |child|
      answer << [child.id, child.birds.map{|bird| bird.name}.join(' ')]
    end

    # # retrieve children from DB, traditional rails way in trivial case
    # # we run into N+1 queries problem
    # # TODO: will try to implement ltree before the interview
    answer = helpers.retrieve_children_with_birds(node[0], [])


    # # retrieve children from DB, pull nodes into hash & then pull all birds for those nodes
    # # only 2 queries needed, but issue of space
    # # TODO: cache hash so we don't recalculate each time
    # nodes = Node.all
    # answer = helpers.get_descendents_and_birds_from_hash(nodes, a)

    render :json => answer
  end

  def update_paths
    nodes = Node.all
    helpers.update_paths(nodes)
    render :json => {'result' => 'updating paths'}
  end
end


