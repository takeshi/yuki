# Copyright (c) 2009-2012 VMware, Inc.
$:.unshift File.expand_path("../lib", __FILE__)

require "yaml"
require "sequel"

require "bundler"
require 'rake/clean'

include Rake::DSL
Bundler::GemHelper.install_tasks

ENV['CI_REPORTS'] = File.join("spec", "artifacts", "reports")

task default: "db:create_migration"

namespace :db do

  desc "Create a Sequel migration in ./db/migrate"
  task :create_migration do
    name = ENV["NAME"]
    abort("no NAME specified. use `rake db:create_migration NAME=add_users`") if !name

    migrations_dir = File.join("db", "migrations")
    version = ENV["VERSION"] || Time.now.utc.strftime("%Y%m%d%H%M%S")
    filename = "#{version}_#{name}.rb"
    FileUtils.mkdir_p(migrations_dir)

    open(File.join(migrations_dir, filename), "w") do |f|
      f.write <<-Ruby
Sequel.migration do
  change do
  end
end
      Ruby
    end

  end

  desc "Perform Sequel migration to database"
  task :migrate do

    require "./config/db"

    m = ARGV.last
    db = DB.name

    if m  =~ /^[-+]?[0-9]+$/
      exec "bundle exec sequel -m ./db/migrations -M #{m} #{db} -E "
    else
      exec "bundle exec sequel -m ./db/migrations #{db} -E "
    end
  end

  task :html do
    exec "java -jar lib/schemaSpy_5.0.0.jar  -dp lib/mysql-connector-java-5.1.25.jar -t mysql -db yuki -host localhost -port 3306 -u root -p root -charset UTF-8 -o ./db/html"
  end

end