class RequireUtil
	def self.loadDir(message,dir)		
		App.logger.info message
		Dir::entries(dir).each  do |file|
			if (file.end_with?("rb"))
				App.logger.info  dir + "/" + file
				load  dir + "/" + file 
			end
		end

	end
end