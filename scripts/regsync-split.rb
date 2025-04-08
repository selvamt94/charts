#! /usr/bin/env ruby

require "json"
require "pathname"
require "yaml"

pwd = Pathname(Dir.pwd)

regsync = YAML.load((pwd + "/config/regsync.yaml").read)

regsync["sync"].sum do |sync|
  sync["tags"]["allow"].count
end.then do |sum|
  puts "total tags to consider: #{sum}"
end

regsync["sync"].each do |sync|
  regsync.merge("sync" => [sync]).then do |regsync|
    (pwd + "split-regsync" + sync["source"]).then do |dir|
      dir.mkpath
      (dir + "split-regsync.yaml").write(YAML.dump(regsync))
    end
  end
end