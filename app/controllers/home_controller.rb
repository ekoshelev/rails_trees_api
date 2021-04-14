class HomeController < ApplicationController
  def common_ancestor
    a = params['a'].to_i
    b = params['b'].to_i

    nodes = Node.where("id = #{a} OR id = #{b}")
    
    # for more efficient queries, note the gem closuretree: https://github.com/ClosureTree/closure_tree
    # also note ltree: https://www.postgresql.org/docs/9.1/ltree.html
    if a != b && (nodes[0] == nil || nodes[1] == nil)
      render :json => {'error' => 'those nodes do not exist, please put a valid id'}
    else
      if a == b
        answer = helpers.find_height_root_lca(nodes[0], nodes[0])
      else
        answer = helpers.find_height_root_lca(nodes[0], nodes[1])
      end

      # solution using a hash O(1) time instead of rails doing a select. potentially faster.
      # nodes = Node.all
      # answer = helpers.find_solution_with_hash(a,b,nodes)
      render :json => answer
    end
  end

end


