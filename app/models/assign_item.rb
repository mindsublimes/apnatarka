class AssignItem < ApplicationRecord
	belongs_to :user
	belongs_to :inventory_item
	belongs_to :chef, class_name: 'User', foreign_key: 'chef_id'
	enum measure: [ :litter, :kg ]
	enum status: [:enough_stock, :limited_stock, :out_of_stock ]
end
