require File.join(File.dirname(__FILE__), 'helpers/test_helper')

include HostAppHelper

class NaturalResourcesTest < ActionController::IntegrationTest
  
  def setup
    recreate_host_app
    install_natural_resources_into_host_app
    install_natural_resources_file('blog')
    execute_in_host_app_root('rails generate natural_resources --generator=ingoweiss:scaffold')
    migrate_host_app_db
    load_host_app
  end

  def test_blub
    get '/posts'
    assert_response :success
  end
  
end