require 'sinatra' 
require 'sinatra/reloader' if development?
require 'sinatra/flash'
#set :port, 3000
#set :environment, :production

enable :sessions
set :sessions_secret, '*&(^#234a)'

chat = ['bienvenido..']
users = Array.new
@userList = []

get '/' do
  erb :registro
end

post '/index' do
  puts "inside post '/index/': #{params}"
  if !users.include?(params[:name]) then
    session[:name] = params[:name]
    users.push session[:name]
    @userList = users
    erb :index
  else
    flash[:error] = "El nombre elegido ya está en uso."
    redirect '/'
  end
end

get '/send' do
  return [404, {}, "Not an ajax request"] unless request.xhr?
  chat << "#{session[:name]} : #{params['text']}"
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

get '/salir' do
  users.delete_if { |element| element == session[:name]}
  session.clear
  redirect '/'
end

