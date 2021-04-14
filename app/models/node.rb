class Node < ApplicationRecord
  self.primary_key = "id"
  belongs_to :parent, class_name: "Node"
  has_many :children, class_name: "Node", foreign_key: "parent_id"
  has_many :birds, class_name: "Bird", foreign_key: "bird_id"
end
