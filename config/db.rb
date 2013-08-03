require "sequel"
require "./util/RequireUtil"
require __dir__ + "/../app"

class DB

	def self.name
		"mysql://root:root@localhost/yuki"
	end

	@@connection = nil
	@@connection = Sequel.connect DB.name
	RequireUtil.loadDir("LoadDataModel",__dir__+"/../model/")

	def self.connection
		@@connection
	end

	def self.[](args)
		@@connection[args]
	end


end