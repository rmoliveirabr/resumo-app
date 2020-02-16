class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def authorize
      unless logged_in?
        redirect_to sign_in_url
      end
  end

  # check if the user is the correct user when there's a user_id or a post.user_id
  def correct_user?
    user_id = session[:user_id]

    @model_name = controller_name.classify
    if @model_name == "User"
      user_id = params[:id]
    end

    if @model_name == "Post" && params[:id]
      user_id = Post.find(params[:id]).user_id
    end

    unless current_user.id == user_id.to_i
      redirect_to user_path current_user
    end
  end

end
