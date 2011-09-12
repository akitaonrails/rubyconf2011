# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
require "rubygems"
require "bundler/setup"
Bundler.require(:default)

include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Breadcrumbs
include Nanoc3::Helpers::Capturing
include Nanoc3::Helpers::Filtering
include Nanoc3::Helpers::HTMLEscape
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Tagging
include Nanoc3::Helpers::Text
include Nanoc3::Helpers::XMLSitemap

def load_translations
  @translations = {}
  I18n.available_locales.each do |locale|
    @translations.merge!( locale => Psych.load_file("lib/#{locale}.yml") )
  end
end

def t(key)
  load_translations unless @translations
  result = @translations[@item[:locale]]
  key.split(/\./).each do |subkey|
    result = result[subkey]
  end
  result
end

def active_language(locale)
  if @item[:locale] == locale
    " class=\"activeLenguage\""
  else
    ""
  end
end

def menu(item)
  if @item[:menu] == item
    " class=\"activeMenu\""
  else
    ""
  end
end
