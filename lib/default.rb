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
  if part == :month
    t("whatsup.months")[date.month - 1]
  else
    date.day
  end
end

def recent_posts
  @site.sorted_articles[0, 10].uniq { |article| article[:filename] }.select { |article| article[:language].to_sym == @item[:locale] }
end
