---
layout: post
title: "Rails Study"
date: 2013-04-24 17:15
comments: true
categories: [RubyRails]
---
## Rails Philosophy ##
1. DRY – “Don’t Repeat Yourself” – suggests that writing the same code over and over again is a bad thing.
2. Convention Over Configuration – means that Rails makes assumptions about what you want to do and how you’re going to do it, rather than requiring you to specify every little thing through endless configuration files.
3. REST is the best pattern for web applications – organizing your application around resources and standard HTTP verbs is the fastest way to go.
    - Using resource identifiers such as URLs to represent resources.
    - Transferring representations of the state of that resource between system components.

## Install Rails ##
1. according to steps on [offical website](http://api.rubyonrails.org/) do 
{% codeblock lang:bash %}
gem install rails; rails new rails-test; cd rails-test; rails server
{% endcodeblock %}

2. when running `rails server` i met such problem:
{% codeblock lang:bash %}
$ rails server
/home/zheng/.rvm/gems/ruby-2.0.0-p0/gems/execjs-1.4.0/lib/execjs/runtimes.rb:51:in `autodetect': Could not find a JavaScript runtime. 
See https://github.com/sstephenson/execjs for a list of available runtimes. (ExecJS::RuntimeUnavailable)
{% endcodeblock %}

This means i need a js engine, and i install the `nodejs` instead, and it's ok

3. try to open `localhost:3000`, and you'll see welcome page

4. Switch to MySQL instead of SQLite3:  
    - the config file is in config/database.yml and change the "development" section like that    
    - add `gem 'mysql2'` to Gemfile
    - run `rake db:create` to check is there any problem 
{% codeblock lang:bash %}
development:
    adapter: mysql2
    encoding: utf8
    database: rails-test
    pool: 5
    username: root
    password:
    socket: /var/run/mysqld/mysqld.sock
{% endcodeblock %}
    
** Remember the test section will also be set to mySQL**

## Hello Rails ##
1. Try to run `rails generate controller home index`  then u will see many files created
    - create home folder and create index page
    - modify `app/views/home/index.html.erb` which will tell us how to show index page
    - rm default index "public/index.html" which is the static page
    - modify `config/routes.rb` uncomment and change to `root :to => "home#index"`
   
   
## Creating a Resource ##
1. Create by scaffold like  `rails generate scaffold Post name:string title:string content:text`

2. Running a Migration
    - Migrations are Ruby classes taht are designed to make it simple to create and modify database tables. it's path `db/migrate/#timestamp#_create_posts.`
    - run the migration:
{% codeblock lang:bash %}
$ rake db:migrate
{% endcodeblock %}
3. Add a Link add `<%=link_to "My Blog", posts_path%>` to index.html.erb

4. Add some data, now using `rails console`
{% codeblock lang:bash %}
p = Post.new(:title => "Title", :content=>"Hellooo", :name=>"myself")
p.save  #if error, try to show "p.errors.full_messages"
{% endcodeblock %}

5. Listing All Posts
    - try to look at `app/controllers/posts_controller.rb` each method is resposed to each action
    - in `app/views/posts/`, each file corresponds to the action name, and u can modify the erb file
{% codeblock lang:ruby %}
class PostsController < ApplicationController
  # GET /posts
  def index
    @posts = Post.all   # => an array of all posts
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end
  ...
end
{% endcodeblock %}

6.Customize Layout, u should create erb file in layout to specific layout, like `app/views/layouts/posts.html.erb`, and the file `application.html.erb` is for whole website

# Detail Study #

## Models ##

## Views ##

## Controllers ##
