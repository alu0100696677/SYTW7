require 'sinatra' 
require 'sinatra/reloader' if development?
require 'sinatra/flash'
#set :port, 3000
#set :environment, :production

enable :sessions
set :session_secret, '*&(^#234a)'

chat = ['Bienvenido..']
users = Array.new
@userList = []

get '/' do
  erb :registro
end

post '/index' do
  puts "inside post '/index/': #{params}"
  if !users.include?(params[:name]) then
    session[:user] = params[:name]
    users.push session[:user]
    @userList = users
    erb :index
  else
    flash[:error] = "El nombre elegido ya esta en uso."
    redirect '/'
  end
end

get '/send' do
  return [404, {}, "Not an ajax request"] unless request.xhr?
  chat << "#{session[:user]} : #{params['text']}"
  nil
end

get '/update' do
  return [404, {}, "Not an ajax request"] unless request.xhr?
  @updates = chat[params['last'].to_i..-1] || []

  @last = chat.size
  erb <<-'HTML', :layout => false
      <% @updates.each do |phrase| %>
        <%= phrase %> <br />
      <% end %>
      <span data-last="<%= @last %>"></span>
  HTML
end

get '/update/usuarios' do
  return [404, {}, "Not an ajax request"] unless request.xhr?
  @userList = users
    erb <<-'HTML', :layout => false
      <ol>
        <% @userList.each do |usuario| %>
          <li id="col" class="bg-primary"><%= usuario %><br></li>
        <% end %>
      </ol>
    HTML
end

get '/salir' do
  users.delete_if { |element| element == session[:user]}
  session.clear
  redirect '/'
end

get '/limpiar' do
  users.clear
  chat.clear
  @userList = users
  redirect '/'
end

