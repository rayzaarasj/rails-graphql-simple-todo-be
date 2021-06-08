# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Todo.delete_all
Category.delete_all

@todos = Array.new()
for i in 0..4
    @todos << Todo.create(
        title: Faker::Lorem.sentence(word_count:3), 
        description: Faker::Lorem.paragraph(sentence_count: 5), 
        deadline:Faker::Time.between(from:DateTime.now()+7, to:DateTime.now()+14)
    )
end

@categories = Array.new()
for i in 0..4
    @categories << Category.create(category:Faker::Lorem.word)
end

def get_random_categories(count)
    random_categories = @categories.dup
    for i in 1..@categories.size-count
        random_categories.delete_at(rand(0..random_categories.size-1))
    end
    return random_categories
end

for i in 0..4
    todo = @todos.at(i)
    puts todo
    random_categories = get_random_categories(rand(1..4))
    for j in 0..random_categories.size-1
        puts random_categories.at(j)
        todo.categories << random_categories.at(j)
    end
end


