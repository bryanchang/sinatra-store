# gem install --version 1.3.0 sinatra
require 'pry'
gem 'sinatra', '1.3.0'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'erubis'
require 'open-uri'
require 'json'
require 'uri'
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
  on_sale = params[:product_on_sale]
  sql = "INSERT INTO products ('name', 'price','on_sale') VALUES ('#{name}','#{price}','#{on_sale}');"
  @rs = @db.execute(sql)
  # @name = name
  # @price = price
  redirect "/products"
end

# search product name on twitter 
get '/products/search' do
  @q = params[:q]
  file = open("http://search.twitter.com/search.json?q=#{URI.escape(@q)}")
  @results = JSON.load(file.read)
  erb :search_results
end
  
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

post '/products/:id/delete' do
  @id = params[:id]
  sql = "DELETE FROM products WHERE id = #{@id};"
  @row = @db.execute(sql)
  redirect '/products'
end

get '/products/search' do
  @q = params[:q]
  file = open("http://search.twitter.com/search.json?q=#{URI.escape(@q)}")
  @results = JSON.load(file.read)
  erb :search_results
end

get '/products/:id:/:q' do
  @q = params[:q]
  @id = params[:q]
  
  file = open("http://search.twitter.com/search.json?q=#{URI.escape(@q)}")
  @results = JSON.load(file.read)
  erb :search_results
end

#AIzaSyAypfaGqJYG0kPrsTGhzfZN2VXg0JcRS-0
https://www.googleapis.com/shopping/search/v1/public/products?key=AIzaSyAypfaGqJYG0kPrsTGhzfZN2VXg0JcRS-0&country=US&q=digital+camera&alt=json