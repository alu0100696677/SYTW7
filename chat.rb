require 'sinatra' 
require 'sinatra/reloader' if development?
#set :port, 3000
#set :environment, :production

chat = ['welcome..']

get('/') { erb :index }

get '/send' do
  return [404, {}, "Not an ajax request"] unless request.xhr?
  chat << "#{request.ip} : #{params['text']}"
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

