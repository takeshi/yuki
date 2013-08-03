
require 'sinatra'

class App < Sinatra::Base

	set :public_folder, __dir__+'/../../js/app'

	configure do
	  enable :logging
	end

	configure :development do
	require "sinatra/reloader"
	  register Sinatra::Reloader
	end

end