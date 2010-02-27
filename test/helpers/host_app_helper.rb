require 'fileutils'

module HostAppHelper
  
  HOST_APP_ROOT = '/tmp/natural_resource_host_app' unless defined? HOST_APP_ROOT
  NATURAL_RESOURCES_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../..')) unless defined? NATURAL_RESOURCES_ROOT
  
  def recreate_host_app
    FileUtils.rm_rf(HOST_APP_ROOT) if File.exist?(HOST_APP_ROOT)
    %x[rails #{HOST_APP_ROOT} -m #{NATURAL_RESOURCES_ROOT}/test/fixtures/host_app_template.rb --quiet]
  end
  
  def install_natural_resources_into_host_app
    Dir.chdir(HOST_APP_ROOT + '/vendor/plugins') do
      File.symlink(NATURAL_RESOURCES_ROOT, 'natural_resource')
    end
    Dir.chdir(HOST_APP_ROOT) do
      %x[rails generate natural_resource --install-custom-responder]
    end
  end
  
  def install_natural_resources_file(layout)
    FileUtils.cp(NATURAL_RESOURCES_ROOT + "/test/fixtures/layouts/#{layout}.txt", HOST_APP_ROOT + '/config/natural_resources.rb')
  end
  
  def load_host_app
    Dir.chdir(HOST_APP_ROOT) do
      ENV["RAILS_ENV"] = "test"
      require File.expand_path(File.join(HOST_APP_ROOT, 'config', 'environment'))
    end
  end
  
  def execute_in_host_app_root(command)
    Dir.chdir(HOST_APP_ROOT) do
      %x[#{command}]
    end
  end
  
  def migrate_host_app_db
    Dir.chdir(HOST_APP_ROOT) do
      %x[rake db:create:all db:migrate db:test:clone_structure]
    end
  end
  
end