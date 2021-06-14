class Category < ApplicationRecord
    validates_presence_of :category
    has_and_belongs_to_many :todos
end
