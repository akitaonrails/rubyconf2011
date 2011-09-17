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
end
