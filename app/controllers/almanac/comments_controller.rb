require_dependency "almanac/application_controller"

module Almanac
  class CommentsController < ApplicationController
    load_and_authorize_resource class: Almanac::Comment
    respond_to :html

    def create
      @comment = Comment.new(params[:comment])
      @post = Post.find(params[:post_id])

      @comment.post = @post

      respond_with(@comment) do |format|
        @comment.spam = (@blog.rakismet_key?) ? @comment.spam? : false

        if @comment.save
          format.html {
            redirect_to post_path(@post.slug),
                        :notice => (@comment.spam) ? "Your comment looks like spam, it won't be published." : "Comment was successfully posted."
          }
        else
          format.html { redirect_to post_path(@post.slug), :alert => 'Something went wrong, try again.' }
        end
      end
    end

    def destroy
      @post = Post.find(params[:post_id])
      @comment = Comment.find(params[:id])
      respond_to do |format|
        if @comment.destroy
          format.html { redirect_to post_path(@post), :notice => 'Comment was successfully deleted.' }
          format.js { render :nothing => true }
        else
          format.html { redirect_to post_path(@post), :alert => 'Something went wrong, try again.' }
        end
      end
    end

    def spam
      @blog = Blog.first
      @comments = Comment.spam

      respond_with(@comments) do |format|
      end
    end
  end
end
