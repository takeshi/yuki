require "multi_json"

require "sinatra/base"
require "sinatra/json"

require 'logger'

class App < Sinatra::Base
  helpers Sinatra::JSON
  @@logger = Logger.new(STDOUT)

  def self.logger
  	@@logger
  end
  
  def self.inherited(base)
    p "extended object #{base.inspect}"
  end

end

require "./config/settings"
require "./util/RequireUtil"
require "./config/db"
RequireUtil.loadDir("LoadController",__dir__ + "/controller")
