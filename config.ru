require 'rubygems' 
require 'bundler' 
 
Bundler.require 

require 'sprockets'
map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'bower_components'
  environment.append_path 'app/assets'

  if ENV['RACK_ENV'] == 'production'
    environment.js_compressor  = :uglify
    environment.css_compressor = :scss
  end

  run environment
end
 
require './mvw_intern' 
run MvwIntern::App
