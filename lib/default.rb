# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
require "rubygems"
require "bundler/setup"
Bundler.require(:default)

include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Capturing
include Nanoc3::Helpers::Filtering
include Nanoc3::Helpers::HTMLEscape
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Text
include Nanoc3::Helpers::XMLSitemap

def normalize_identifier(item, force_locale = nil)
  identifier = if item.children.size > 0 || item.identifier == '/' || item.identifier == "/#{item[:locale]}/"
    item.identifier + 'index.html'
  else
    page = item.identifier.gsub(/\/$/, '')
    page = "/index" if page =~ /locale/
    page = "/sitemap" if page =~ /sitemap/
    page = "/robots" if page =~ /robots/
    "#{page}.#{item[:extension]}"
  end
  identifier.gsub!(/^\/([en|br]+)/, "/#{force_locale}") if force_locale
  identifier
end

def load_translations
  @translations = {}
  I18n.available_locales.each { |locale| @translations.merge!( locale => Psych.load_file("lib/#{locale}.yml") ) }
end

def t(key)
  load_translations unless @translations
  key.split(/\./).inject(@translations[@item[:locale]]) { |result, subkey| result = result[subkey] }
end

def active_language(locale)
  @item[:locale] == locale ? " class=\"activeLenguage\"" : ""
end

def menu(item)
  @item[:menu] == item ? " class=\"activeMenu\"" : ""
end

def parse_date(date, part)
  part == :month ? t("whatsup.months")[date.month - 1] : date.day
end

def recent_posts
  @site.sorted_articles.uniq { |article| article[:filename] }.select { |article| article[:language].to_sym == @item[:locale] }
end

def speakers(direction = :none)
  unless @speakers
    @speakers = Dir["lib/speakers/*.yml"].map { |file| YAML.load_file(file) }
    @speakers.each do |speaker|
      speaker[:talk_slug] = "/talks/#{speaker[:main_speaker_slug] || speaker[:slug]}.html"
    end
  end

  case direction
  when :left
    @speakers[0..@speakers.size/2-1]
  when :right
    @speakers[@speakers.size/2..@speakers.size-1]
  else
    @speakers
  end
end

def random_speakers_list(total = 24)
  speakers.select { |speaker| speaker[:avatar_url] !~ /speakers\.jpg/ }.shuffle[0..(total - 1)]
end

def load_speakers(item)
  return [nil, nil] unless item[:main_speaker_slug]
  speaker = YAML.load_file("lib/speakers/#{item[:main_speaker_slug]}.yml")
  cospeaker = item[:co_speaker_slug].empty? ? nil : YAML.load_file("lib/speakers/#{item[:co_speaker_slug]}.yml")
  [speaker, cospeaker]
end

def load_talks
  @talks = YAML.load_file("lib/talk_grid.yml")
  @talks.each do |day, grid|
    grid.each do |row|
      [:both, :room_a, :room_b].each do |room|
        next unless row.has_key?(room)
        if row[room] == 'unconfirmed'
          row[room] = { :slug => '#', :title_en => "unconfirmed", :title_br => "a confirmar" }
        else
          filename = "/talks/#{row[room]}.html"
          row[room] = YAML.load_file("content" + filename)
          row[room][:slug] = filename
        end
      end
      row[:both] = { :slug => '#', :title_en => row[:both_en], :title_br => row[:both_br] } if row[:both_en]
    end
  end
  @talks
end

