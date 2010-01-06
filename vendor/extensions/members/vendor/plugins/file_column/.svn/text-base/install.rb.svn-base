require 'pathname'

def path(s); Pathname.new(s).cleanpath.to_s end

this_path = path File.dirname(__FILE__)
require path(this_path + '/../../../config/boot')
require 'fileutils'

config_path               = path("#{RAILS_ROOT}/config")
initializers_path         = path("#{config_path}/initializers")
initializer_template_path = path(this_path + "/install/initializer.rb")
initializer_destination   = path("#{initializers_path}/file_column.rb")

FileUtils.cp initializer_template_path, initializer_destination
