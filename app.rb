ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require_relative 'data_mapper_setup'
require './models/link'
require './models/tag'
require 'sinatra/flash'

class BookmarkManager < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

  get '/' do
    ''
  end

  get '/links' do
    @links = Link.all
    erb :links
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/add' do
    link = Link.new(url: params[:url], title: params[:title])
    params[:tags].split.each do |tag|
      link.tags << Tag.first_or_create(name: tag)
    end
    link.save
    redirect ('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links'
  end

  get '/user/new' do
    erb :'user/new'
  end

  post '/user' do
    user = User.new(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    if (user.save)
      session[:user_id] = user.id
      redirect ('/links')
    else
      flash.now[:errors] = user.errors.full_messages
      erb :'user/new'
    end

  end

  get '/user/login' do
    erb :'user/login'
  end

  post '/user/login' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect ('/links')
    else
      flash.now[:errors] = ["The email or password is incorrect"]
      erb :'user/login'
    end
  end

  get '/user/logout' do
    @last_user = current_user
    @current_user = nil
    session[:user_id] = nil
    erb :'user/logout'
  end
  
  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
