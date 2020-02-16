class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :rate]
  before_action :authorize, except: [:index, :show]
  before_action :correct_user?, except: [:index, :show]

  # GET /posts
  # GET /posts.json
  def index

    if params[:search].present? # search posts
      @parameter = params[:search].downcase
      if @parameter.size >= 3
        @posts = Post.all.where("lower(title) LIKE :search", search: "%#{@parameter}%")
      else
        @posts = Post.all.order(:title)
      end
    elsif params[:format].present? # filter by user
      @posts = Post.where(user_id: current_user.id).order(:title)
    else # show all posts
      @posts = Post.all.order(:title)
    end
  end

  # GET /search
  def search
    if !params[:search].blank?
      @parameter = params[:search].downcase
      @posts = Post.all.where("lower(title) LIKE :search", search: "%#{@parameter}%")
    else
      @posts = Post.all
    end

    redirect_to posts_url
  end

  # GET /rate
  def rate
    if !params[:rate_id].blank?
      @post.rating = params[:rate_id].to_i
      @post.save
    end

    redirect_to @post
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    # get list of tags for search
    @tags = Tag.pluck(:tag_text).sort

    # check if the post can be edited
    @can_edit = current_user.present? && @post.user_id == current_user.id

    # increment views
    if !@post.views.present?
      @post.views = 1
    else
      @post.views = @post.views + 1
    end

    @post.save
  end

  # GET /posts/new
  def new
    @post = Post.new
    @categories = Category.all
  end

  # GET /posts/1/edit
  def edit
    @categories = Category.all
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_url, notice: 'Resumo criado com sucesso.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      @post.categories.clear
      if params[:cat_list]
        params[:cat_list].each do |cat_id|
          unless cat_id.empty?
            cat = Category.find(cat_id)
            @post.categories << cat
          end
        end
      end

      if @post.update(post_params)
        format.html { redirect_to posts_url, notice: 'Resumo atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Resumo excluído com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :description, :published, :favorite, :user_id)
    end
end
