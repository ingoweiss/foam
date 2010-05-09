h2. Relay

p. Relay is a meta generator for generating scaffold for a Rails application from a description of the application's resource layout

h3. Installation

bc.. gem install relay

h3. Usage

p. First we need to install relay

bc(ruby).. # Gemfile
gem 'relay'
gem 'ingoweiss_generators' # or any other generator that can be driven by relay (see below)

p. Then, we run relay once to create the 'config/resource_layout.rb' file

bc.. # reply with 'yes' when prompted 'Create resource layout file?'
rails generate resource_layout

p. Next, edit 'config/resource_layout.rb' to match the resource layout you want to generate. Presently, there is really not much to the syntax: 'many' is for plural and 'one' for singular resources, resource attribute name/type pairs are passed in as an options hash:

bc(ruby) # config/resource_layout.rb
ResourceLayout.define do
  many :posts, :title => :string, :body => :text do
    many :comments, :body => :text
    one :approval
  end
end

p. Lastly, run relay using the scaffold generator of your choice. Relay expects a scaffold generator which, in addition to the usual 'name' and 'attributes' arguments supports a 'scope' option of type array for specifying parent resources and a 'skip-routes' option for skipping route definition injection (so that relay can inject the nested route definition at the end instead). The "ingoweiss_generators":http://github.com/ingoweiss/ingoweiss_generators gem contains the 'ingoweiss:scaffold' generator that meets those requirements

bc.. rails generate resource_layout --generator=ingoweiss:scaffold

This will generate scaffold for the followign resources:

* /posts
* /posts/123/comments
* /posts/123/approval

Relay is experimental and expected to change

Copyright (c) 2010 Ingo Weiss, released under the MIT license