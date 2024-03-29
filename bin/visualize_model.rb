#!/usr/bin/env ruby
# Copyright (c) 2009-2012 VMware, Inc.
#
# Note, I didn't try to make this a particularly clean implementation.  It is
# somewhat of a hack just to printout the CC schema.
#
# It might be nice to factor this out into a common tool.
#
require "rubygems"
require "bundler/setup"
require "graphviz"
require "sequel"

# ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)
# $:.unshift(File.expand_path("../../lib", __FILE__))

db = Sequel.connect("sqlite:///")
Sequel::Model.plugin :timestamps
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :subclasses

Sequel.extension :migration
migrations_dir = __dir__ + "/../db/migrations"
Sequel::Migrator.apply(db, migrations_dir)

require  __dir__ + "/../app"

g = GraphViz.new(:G, :type => :digraph, :rankdir => "LR",
                 :label => "*** REVIEW HIERARCHY ONLY. ATTRIBUTES ARE NOT COMPLETE ***")

def short_name(str)
  name = str.split("::").last
end

Sequel::Model.descendents.each do |c|
  name = short_name(c.name)
  field_str = nil
  c.columns.each do |col|
    if field_str.nil?
      field_str = ""
    else
      field_str += "|"
    end
    field_str += "<#{col}>- #{col}\\l"
  end
  label = "<entity_name>#{name}|" + field_str
  g.add_nodes(name, "label" => label, "shape" => "record")
  puts ["label" => label, "shape" => "record"]
end

associations = {}
Sequel::Model.descendents.each do |c|
  c.associations.each do |a|
    ar = c.association_reflection(a)
    ac = ar.associated_class
    c_name = short_name(c.name)
    ac_name = short_name(ac.name)

    if associations[ac_name].nil? || associations[ac_name][c_name].nil?
      case ar[:type]
      when :many_to_many
        if ar[:join_table]
          join_table = ar[:join_table].to_s
          left_key = ar[:left_key]
          right_key = ar[:right_key]
          label = "#{join_table}|<#{left_key}> -#{left_key}\\l|<#{right_key}> -#{right_key}\\l"
          g.add_nodes(join_table, "label" => label, "shape" => "record")
          arrowhead = "crow"
          arrowtail = "crowodot"

          g.add_edges({join_table => left_key },
                      {short_name(c.name) => :id },
                      "dir" => "both",
                      "arrowhead" => "dot",
                      "arrowtail" => "crowodot",
                      "minlen" => 2)
          g.add_edges({join_table => right_key },
                      {short_name(ac.name) => :id },

                      "dir" => "both",
                      "arrowhead" => "dot",
                      "arrowtail" => "crowodot",
                      "minlen" => 2)
        else
          # NOTE: this may not be correct, the current schema
          # does not have such an example
          g.add_edges({short_name(ac.name) => ar[:key] },
                      {short_name(c.name) => :id },
                      "dir" => "both",
                      "arrowhead" => "crowodot",
                      "arrowtail" => "crowodot",
                      "minlen" => 2)
        end
      when :one_to_many
        g.add_edges({short_name(ac.name) => ar[:key] },
                    {short_name(c.name) => :id },
                    "dir" => "both",
                    "arrowhead" => "dot",
                    "arrowtail" => "crowodot",
                    "minlen" => 2)
      when :many_to_one
        g.add_edges({short_name(ac.name) => :id},
                    {short_name(c.name) => ar[:key]},
                    "dir" => "both",
                    "arrowhead" => "crowodot",
                    "arrowtail" => "dot",
                    "minlen" => 2)
      end

      associations[c_name] ||= {}
      associations[c_name][ac_name] = true
    end
  end
end

# file_name = File.expand_path("../../docs/model.png", __FILE__)
# g.output(:png => file_name)
# puts "Model output to #{file_name}"