ENV["RAILS_ENV"] = "test"
require 'rubygems'
require 'ruby-debug'
require File.join(File.dirname(__FILE__), 'host_app_helper')
include HostAppHelper

recreate_host_app
install_foam_into_host_app
install_resource_layout_file('blog')
execute_in_host_app_root('rails generate resource_layout --generator=ingoweiss:scaffold')
migrate_host_app_db
load_host_app
require 'rails/test_help'
