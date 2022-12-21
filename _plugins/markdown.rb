=begin
  Jekyll tag to include Markdown text from _includes directory preprocessing with Liquid.
  Usage:
    {% markdown <filename> %}
  Dependency:
    - kramdown
=end
# module Jekyll
#   class MarkdownTag < Liquid::Tag
#     def initialize(tag_name, text, tokens)
#       super
#       @text = text.strip
#     end
#     require "kramdown"
#     def render(context)
#       tmpl = File.read File.join Dir.pwd, "_includes", @text
#       site = context.registers[:site]
#       tmpl = (Liquid::Template.parse tmpl).render site.site_payload
#       html = Kramdown::Document.new(tmpl).to_html
#     end
#   end
# end
# Liquid::Template.register_tag('markdown', Jekyll::MarkdownTag)


# From: https://github.com/ainc/awesomeinc2013/blob/master/Rakefile

require "rubygems"
require "tmpdir"

require "bundler/setup"
require "jekyll"

ENV["JEKYLL_ENV"] = "production"

desc "Generate blog files"
task :generate do
  Jekyll::Site.new(Jekyll.configuration({
    "source"      => ".",
    "destination" => "_site"
  })).process
end


desc "Generate and publish blog to gh-pages"
task :publish => [:generate] do
  Dir.mktmpdir do |tmp|
    cp_r "_site/.", tmp

    pwd = Dir.pwd
    Dir.chdir tmp

    system "git init"
    system "git add ."
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m #{message.inspect}"
    system "git remote add origin git@github.com:sbryngelson/bryngelson_personal_template.git"
    system "git push origin master --force"

    Dir.chdir pwd
  end
end
