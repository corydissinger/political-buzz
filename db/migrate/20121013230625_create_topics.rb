class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string  :name
      t.integer :count
    end

    create_table :statements do |t|
      t.integer :topic_id
      t.text :transcript
      t.string :url
      t.string :speaker
      t.date :date
    end

    create_table :categories do |t|
      t.string :name
    end
    
    create_table :categories_statements, :id => false do |t|
      t.integer :category_id
      t.integer :statement_id
    end
    
    create_table :articles do |t|
      t.integer :category_id
      t.string :url
    end    
    
    add_index(:topics, [:name], :unique => true)
    add_index(:categories, [:name], :unique => true)
    add_index(:categories_statements, [:category_id, :statement_id], :unique => true)
    add_index(:articles, [:url], :unique => true)
  end
end
