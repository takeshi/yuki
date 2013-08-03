
class  App

  get "/" do
    send_file File.join(settings.public_folder, "index.html")
  end

  get "/app/data_models" do
    json DB[:data_models].all.map{|item| item.to_json }
  end


end