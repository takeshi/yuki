Gem::Specification.new do |gem|
  gem.authors       = ["Takeshi Kondo"]
  gem.email         = ["takeshi.kondo@gmail.com"]
  gem.description   = %q{}
  gem.summary       = %q{}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\) + Dir.glob("public/**/*")
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "yuki"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.2"

  gem.add_development_dependency("rdoc", "4.0.1")
  gem.add_development_dependency("rake", "10.0.4")

  gem.add_development_dependency("thin", "1.5.1")
  gem.add_development_dependency("rspec", "2.13.0")
  gem.add_development_dependency("rack-test", "0.6.2")
  gem.add_development_dependency("simplecov", "0.7.1")
  gem.add_development_dependency("debugger", "1.5.0")

  gem.add_dependency("sinatra", "1.4.2")
  gem.add_dependency("sinatra-contrib", "1.4.0")
  gem.add_dependency("vegas", "0.1.11")
  gem.add_dependency("sequel")
  gem.add_dependency("mysql")

  gem.add_dependency("ruby-graphviz")

  
end