class Node < ApplicationRecord
  self.primary_key = "id"
  belongs_to :parent, class_name: "Node", optional: true
  has_many :children, class_name: "Node", foreign_key: "parent_id"
  has_many :birds


end
