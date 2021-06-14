class Todo < ApplicationRecord
    validates_presence_of :title
    validates_presence_of :description
    validates_presence_of :deadline
    has_and_belongs_to_many :categories
end
