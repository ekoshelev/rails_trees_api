# README
To start application, adjust your database.yml settings with your postgres password and run:

`bundle install`

`rails db:seed`

`rails s`


* Ruby version: 2.6.3

* Rails version: 6.0.3.6

For the solution to querying trees in rails, we use the ltree functionality of postgres to save the paths of each root to node in a column :paths associated with each node. By precalculating these paths in db:seed, we can greatly increase the speed of querying to find children of a node, as well as the root, least common ancestor, and depth of the least common ancestor.

The evolution of this solution was as follows:

Solution 1: Populate a hash with all node data such that hash[child_id] = hash[parent_id]. Recursively iterate through to find the path from root to node and use that to calculate root, lca, and depth. 
This solution takes O(NC) time for N rows and C columns and for a very large dataset, would need way more space than necessary to parse obects and store the hash.

Solution 2: Create rails self associations for Node using belongs_to :parent and has_many :children. Use this association to iterate through parent and/or child nodes to get the solution. This creates the N+1 query problem where if a parent has 1000 children, we need to create 1000 queries to get those children. This takes less space than solution 1, but still isn't very efficient.

Solution3: Add ltree to postgres database and store the path from root to node in the :path column of a node. This cuts runtime significantly because to find child nodes we only need to select nodes where the path is a subpath of our desired node's path, thus greatly reducing the number of queries from solution 2.

If we were to continue this project, some things I would do are: write rspec tests, test different gems to find fastest runtime, implement gist index on table
