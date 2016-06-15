
ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require 'sinatra/flash'
require_relative 'data_mapper_setup'


class BookMarkM < Sinatra::Base

  register Sinatra::Flash
  
  enable :sessions
  set :session_secret, 'super secret'

  get '/' do
    'Hello BookMarkM!'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links' do
    link = Link.create(title: params[:title], url: params[:url])
    params[:tags].split.each do |tag|
      link.tags << Tag.first_or_create(name: tag)
    end
    link.save
    redirect '/links'
  end

  get '/links/new' do
    erb :'links/links_new'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/user/new' do
     @user_email ||= ""
    erb :'user/new'
  end

  post '/user/new' do
    user = User.new(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    if user.save
      session[:user_id] = user.id
      redirect to('/links')
    else
      flash.now[:notice] = "Password and confirmation password do not match"
      @user_email = user.email
      erb :'user/new'
    end
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
