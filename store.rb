# gem install --version 1.3.0 sinatra
require 'pry'
gem 'sinatra', '1.3.0'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'erubis'
require 'open-uri'
require 'json'
# require "better_errors"

# configure :development do
#   use BetterErrors::Middleware
#   BetterErrors.application_root = File.expand_path("..", __FILE__)
# end

before do
  @db = SQLite3::Database.new "store.sqlite3"
  @db.results_as_hash = true
end


get '/' do
  erb :home
end

# show user index
get '/users' do
  @rs = @db.execute('SELECT * FROM users;')
  erb :show_users
end

get '/users.json' do
  @rs = @db.execute('SELECT id, name FROM users;')
  @rs.to_json
end
  
# show product index
get '/products' do
  @rs = @db.execute('SELECT * FROM products;')
  erb :show_products
end

# gets inputs for new products 
get '/products/new' do
  erb :new_product
end
 
# create new product
post '/products' do
  name = params[:product_name]
  price = params[:product_price]
  sql = "INSERT INTO products ('name', 'price') VALUES ('#{name}','#{price}');"
  @rs = @db.execute(sql)
  # @name = name
  # @price = price
  redirect "/products"
end

get
  
# show product details
get '/products/:id' do
  @id = params[:id]
  sql = "SELECT * FROM products WHERE id = #{@id};"
  @row = @db.get_first_row sql
  erb :show_products_details
end  

# gets inputs for editting
get '/products/:id/edit' do
  @id = params[:id] # need an @id object to pass in
  sql = "SELECT * FROM products WHERE id = #{@id};"
  @row = @db.get_first_row sql
  erb :edit_products
end

# update the products
post '/products/:id' do
  @id = params[:id]
  name = params[:product_name]
  price = params[:product_price]
  sql = "UPDATE products SET name='#{name}', price=#{price} WHERE id=#{@id}"
  @row = @db.get_first_row sql
  sql = "SELECT * FROM products WHERE id = #{@id};"
  @row = @db.get_first_row sql
  erb :show_products_details
end  

get '/products/:id/delete' do
  @id = params[:id]
  sql = "SELECT * FROM products WHERE id = #{@id};"
  @row = @db.get_first_row sql
  erb :delete_products
end

post '/products' do
end