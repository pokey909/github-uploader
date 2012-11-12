#!/usr/bin/ruby

require 'rubygems'
require 'github_api'

if ARGV.length < 4
abort "Usage: createGithubDownload.rb <userContext> <token> <reponame> <filename> [<description>]\n Example: createGithubDownload.rb client_libs_external /tmp/someFile.tar.gz \"This is an optional description\""
end

context = ARGV[0]
token = ARGV[1]
repo = ARGV[2]
file = ARGV[3]
desc=""
if ARGV[4] != nil
desc = ARGV[4]
end

github = Github.new do |config|
  config.oauth_token = token 
end

# if this download exists already, delete it
github.repos.downloads.list context, repo do |dl|
        if dl.name == file
                github.repos.downloads.delete context, repo, dl.id
        end
end

bytes = File.size file
res = github.repos.downloads.create context, repo, "name" => file, "size" => bytes, "description" => desc
github.repos.downloads.upload res, file


puts "Created download for " + repo + " repo.";
puts "Name: " + file;
puts "Desc: " + desc;

