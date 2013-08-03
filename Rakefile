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
    config_file = ENV["CLOUD_CONTROLLER_NG_CONFIG"]
    config_file ||= File.expand_path("../config/cloud_controller.yml", __FILE__)

    config = VCAP::CloudController::Config.from_file(config_file)
    VCAP::CloudController::Config.db_encryption_key = config[:db_encryption_key]

    Steno.init(Steno::Config.new(:sinks => [Steno::Sink::IO.new(STDOUT)]))
    db_logger = Steno.logger("db.migrations")

    db = VCAP::CloudController::DB.connect(db_logger, config[:db])
    VCAP::CloudController::DB.apply_migrations(db)
  end

end

