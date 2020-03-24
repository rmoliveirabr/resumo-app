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
        #@posts = Post.all.where("lower(year) LIKE :search", search: "%#{@parameter}%")
        @posts = Post.joins(:year).where("lower(years.year_text) LIKE :search", search: "%#{@parameter}%")
      else
        #@posts = Post.all.order(:year)
        @posts = Post.joins(:year).order('years.year_text')
      end
    elsif params[:format].present? # filter by user
      #@posts = Post.where(user_id: current_user.id).order(:year)
      @posts = Post.joins(:year).where(user_id: current_user.id).order('years.year_text')
    else # show all posts
      #@posts = Post.joins('LEFT OUTER JOIN years ON posts.year_id = years.id').order('years.year_text')
      @posts = Post.joins(:year).order('years.year_text')
    end
  end

  # GET /search
  def search
    if !params[:search].blank?
      @parameter = params[:search].downcase
      #@posts = Post.all.where("lower(year) LIKE :search", search: "%#{@parameter}%")
      @posts = Post.joins(:year).where("lower(years.year_text) LIKE :search", search: "%#{@parameter}%")
    else
      #@posts = Post.all
      @posts = Post.joins(:year).order('years.year_text')
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
    @post.year = Year.new
    @post.subject = Subject.new
    @post.topic = Topic.new

    @years = Year.pluck(:year_text).sort
    @subjects = Subject.pluck(:subject_text).sort
    @topics = Topic.pluck(:topic_text).sort
  end

  # GET /posts/1/edit
  def edit
    # get list of data for search on autocomplete
    @years = Year.pluck(:year_text).sort
    @subjects = Subject.pluck(:subject_text).sort
    @topics = Topic.pluck(:topic_text).sort
  end

  # POST /posts
  # POST /posts.json
  def create
    @year_id = getYearFromText(params[:year_text])
    @subject_id = getSubjectFromText(params[:subject_text])
    @topic_id = getTopicFromText(params[:topic_text])

    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.year_id = @year_id
    @post.subject_id = @subject_id
    @post.topic_id = @topic_id

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
      @year_id = getYearFromText(params[:year_text])
      @subject_id = getSubjectFromText(params[:subject_text])
      @topic_id = getTopicFromText(params[:topic_text])

      @post.year_id = @year_id
      @post.subject_id = @subject_id
      @post.topic_id = @topic_id

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
      params.require(:post).permit(:year, :subject, :topic, :published, :favorite, :user_id)
    end

    def getYearFromText(text)
      @year = Year.find_by(year_text: text)
      if !@year.present?
        @year = Year.new
        @year.year_text = text
        @year.save
      end
      return @year.id
    end

    def getSubjectFromText(text)
      @subject = Subject.find_by(subject_text: text)
      if !@subject.present?
        @subject = Subject.new
        @subject.subject_text = text
        @subject.save
      end
      return @subject.id
    end

    def getTopicFromText(text)
      @topic = Topic.find_by(topic_text: text)
      if !@topic.present?
        @topic = Topic.new
        @topic.topic_text = text
        @topic.save
      end
      return @topic.id
    end
end
