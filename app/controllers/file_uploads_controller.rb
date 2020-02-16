class FileUploadsController < ApplicationController
  before_action :authorize
  before_action :correct_user?

  def new
    @post = Post.find(params[:post_id])
  end

  def create
    @post = Post.find(params[:post_id])
    @post.files.attach(params[:post][:files])
    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post.files.find(params[:id]).purge
    redirect_to post_path(@post)
  end
end
