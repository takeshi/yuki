require "multi_json"

require "sinatra/base"
require "sinatra/json"

require "./config/main"

class App < Sinatra::Base
  helpers Sinatra::JSON

  get "/" do
    send_file File.join(settings.public_folder, "index.html")
  end

  get "/app/products.json" do
    json [{name: "iPad"}, {name: "Nexus 7"}, {name: "Samsung S4"}]
  end

end