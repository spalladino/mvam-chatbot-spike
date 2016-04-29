set :views, File.expand_path('../views', __FILE__)

get '/' do
  erb :index, layout: :layout
end
