use ActiveRecord::ConnectionAdapters::ConnectionManagement

set :bind, ENV['bind'] || 'localhost'
set :port, ENV['PORT'] || '4567'
set :views, File.expand_path('../views', __FILE__)
set :public_folder, File.expand_path('../public', __FILE__)

get '/' do
  @users = User.all
  erb :index, layout: :layout
end

get '/users' do
  @users = User.all
  erb :index, layout: :layout
end

get '/users/:id' do
  @user = User.find(params[:id])
  @messages = @user.message_logs.order('message_logs.id DESC')
  erb :user, layout: :layout
end

after do
  ActiveRecord::Base.clear_active_connections!
end
