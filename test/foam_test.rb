require File.join(File.dirname(__FILE__), 'helpers/test_helper')

class FoamTest < ActionController::IntegrationTest
  
  def setup
  end

  def test_blog
    get '/posts'
    assert_response :success
    get '/posts/new'
    assert_response :success
    post '/posts', :post => {:title => 'Scaffolding for fun and profit', :body => 'Scaffoldig can be useful if...'}
    follow_redirect!
    assert_response :success
    @post = Post.find_by_title('Scaffolding for fun and profit')
    assert_not_nil @post
    get "/posts/#{@post.to_param}/comments/new"
    assert_response :success
    post "/posts/#{@post.to_param}/comments", :comment => {:body => 'Great post!'}
    follow_redirect!
    assert_response :success
    @comment = @post.comments.find_by_body('Great post!')
    assert_not_nil @comment
    get "/posts/#{@post.to_param}/approval/new"
    assert_response :success
    post "/posts/#{@post.to_param}/approval"
    follow_redirect!
    # assert_response :success
    # responder redirect does not work here: https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/4077
    assert_not_nil @post.approval
  end
  
end