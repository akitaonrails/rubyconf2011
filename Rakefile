require "rubygems"
require "bundler/setup"
Bundler.require(:default)

require 'nanoc3/tasks'

namespace :create do

  desc "Creates a new article. Params: title, order, lang"
  task :article do
    require 'active_support/all'
    @ymd = Time.now.to_s(:db).split(' ')[0]
    if !ENV['title']
      $stderr.puts "\t[error] Missing title argument.\n\tusage: rake create:article title='article title' order=1 lang=en"
      exit 1
    end
    @lang = ENV['lang'] || 'en'
    @order = ENV['order']

    title = ENV['title'].capitalize
    path, filename, full_path = calc_path(title)

    if File.exists?(full_path)
      $stderr.puts "\t[error] Exists #{full_path}"
      exit 1
    end

    template = <<TEMPLATE
---
language: #{@lang}
created_at: #{@ymd}
excerpt:
kind: article
publish: true
title: "#{title.titleize}"
---

TODO: Add content to `#{full_path}.`
TEMPLATE

    FileUtils.mkdir_p(path) if !File.exists?(path)
    File.open(full_path, 'w') { |f| f.write(template) }
    $stdout.puts "\t[ok] Edit #{full_path}"
  end

  def calc_path(title)
    path = "content/whatsup/"
    filename = @ymd + "-" + (@order ? @order + "-" : "") + title.parameterize('_') + ".html"
    [path, filename, path + filename]
  end
end


namespace :utils do
  desc "sync avatars from the call for papers server"
  task :sync_avatars do
    `rsync -avz -e ssh root@akitaonrails.com:/var/webapps/rubyconf2011/public/system/ ./content/images/`
  end

  desc "sync the sqlite3 call for papers database"
  task :sync_papers do
    `scp root@akitaonrails.com:/var/webapps/rubyconf2011/db/production.sqlite3 ./tmp/`
  end

  desc "generate speakers profile and talk files"
  task :generate_talks do
    require 'sqlite3'
    require 'fileutils'
    require 'to_slug'
    require 'active_support/all'

    exit unless File.exists?("./tmp/production.sqlite3")
    FileUtils.rm_rf "./lib/speakers"
    FileUtils.rm_rf "./lib/talks"
    FileUtils.mkdir_p "./lib/speakers"
    FileUtils.mkdir_p "./lib/talks"

    db = SQLite3::Database.new "./tmp/production.sqlite3"
    db.results_as_hash = true
    row_index_rand = (0..27)
    db.execute "select * from talks where selected = 't' and confirmed = 't'" do |row|
      row.delete_if { |key,value| row_index_rand.include?(key) }
      slug = "#{row["full_name"].to_slug}-#{row["id"]}"
      cospeaker_slug = "#{row["cospeaker_name"].to_slug}-#{row["id"]}"
      speaker = {
        :id => row["id"],
        :slug => slug,
        :full_name => row["full_name"],
        :email => row["email"],
        :twitter => row["twitter"],
        :blog_url => row["blog_url"],
        :company => row["company"],
        :bio_br => row["bio"].gsub(/\r/, ""),
        :bio_en => row["bio"].gsub(/\r/, ""),
        :country => row["country"],
        :avatar_thumb_url => "/images/avatars/#{row["id"]}/thumb/#{row["avatar_file_name"]}",
        :avatar_medium_url => "/images/avatars/#{row["id"]}/medium/#{row["avatar_file_name"]}",
        :avatar_url => "/images/avatars/#{row["id"]}/original/#{row["avatar_file_name"]}",
      }
      co_speaker = row["cospeaker_name"].blank? ? nil : {
        :id => row["id"],
        :main_speaker_name => row["full_name"],
        :main_speaker_slug => slug,
        :slug => cospeaker_slug,
        :full_name => row["cospeaker_name"],
        :email => row["cospeaker_email"],
        :twitter => row["cospeaker_twitter"],
        :blog_url => row["cospeaker_blog_url"],
        :company => row["company"],
        :bio_br => row["cospeaker_bio"].gsub(/\r/, ""),
        :bio_en => row["cospeaker_bio"].gsub(/\r/, ""),
        :country => row["country"],
        :avatar_thumb_url => "/images/avatar_cospeakers/#{row["id"]}/thumb/#{row["avatar_cospeaker_file_name"]}",
        :avatar_medium_url => "/images/avatar_cospeakers/#{row["id"]}/medium/#{row["avatar_cospeaker_file_name"]}",
        :avatar_url => "/images/avatar_cospeakers/#{row["id"]}/original/#{row["avatar_cospeaker_file_name"]}",
      }
      talk = {
        :id => row["id"],
        :main_speaker_slug => slug,
        :main_speaker_name => row["full_name"],
        :co_speaker_slug => cospeaker_slug,
        :co_speaker_name => row["cospeaker_name"],
        :title_br => row["title"],
        :title_en => row["title"],
        :description_br => row["description"].gsub(/\r/, ""),
        :description_en => row["description"].gsub(/\r/, ""),
        :country => row["country"],
        :confirmed => row["confirmed"] == 't',
        :selected => row["selected"] == 't'
      }
      File.open("./lib/speakers/#{slug}.yml", "w+") do |file|
        file.write(speaker.to_yaml)
      end
      File.open("./lib/speakers/#{cospeaker_slug}.yml", "w+") do |file|
        file.write(co_speaker.to_yaml)
      end if co_speaker
      File.open("./lib/talks/#{slug}.yml", "w+") do |file|
        file.write(talk.to_yaml)
      end
    end
  end
end
