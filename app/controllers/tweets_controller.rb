class TweetsController < ApplicationController

    get '/tweets' do
      if logged_in?
        @tweets = Tweet.all
        erb :index
      else
        flash[:message] = "You must be logged in to view tweets."
        redirect :'/login'
      end
    end
  
    get '/tweets/new' do
      if logged_in?
        erb :'/tweets/create_tweet'
      else
        flash[:message] = "You must be logged in to tweet."
        redirect :'/login'
      end
    end
  
    post '/tweets' do
      if params[:content].empty?
        flash[:message] = "Your tweet is empty!"
  
        redirect :'/tweets/new'
      else
        @tweet = Tweet.create(params)
        @tweet.user_id = session[:user_id]
        @tweet.save
  
        flash[:message] = "Successfully tweeted!"
        redirect :"tweets/#{@tweet.id}"
      end
    end
  
    get '/tweets/:id' do
      if logged_in?
        @tweet = Tweet.find_by_id(params[:id])
        erb :'/tweets/show_tweet'
      else
        flash[:message] = "You must be logged in to view tweets."
        redirect :'/login'
      end
    end
  
    get '/tweets/:id/edit' do
      if logged_in?
        @tweet = Tweet.find(params[:id])
        if @tweet && session[:user_id] == @tweet.user_id
          erb :'/tweets/edit_tweet'
        else
          flash[:message] = "You must be the tweet owner to edit."
          redirect :'/tweets'
        end
      else
        flash[:message] = "You must be logged in to edit tweets."
        redirect :"/login"
      end
    end
  
    patch '/tweets/:id' do
      @tweet = Tweet.find_by_id(params[:id])
  
      if params[:content].empty?
        flash[:message] = "Your tweet is empty!"
        redirect :"/tweets/#{@tweet.id}/edit"
      elsif params[:content] == @tweet.content
        flash[:message] = "There has been no changes to the tweet!"
        redirect :"/tweets/#{@tweet.id}"
      else
        @tweet.content = params[:content]
        @tweet.save
        flash[:message] = "Successfully edited tweet!"
        redirect :"/tweets/#{@tweet.id}"
      end
    end
  
    #DELETE TWEETS
      post '/tweets/:id/delete' do
        if logged_in?
          @tweet = Tweet.find(params[:id])
          if @tweet && @tweet.user_id == session[:user_id]
            @tweet.delete
            flash[:message] = "Successfully deleted tweet!"
            redirect :'/tweets'
          else
            flash[:message] = "You do not have permission to delete this tweet."
            redirect :'/tweets'
          end
        else
          flash[:message] = "You must be logged in to delete a tweet."
          redirect :'/login'
        end
      end
  end
  