class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :authorize
  before_action :correct_user?

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  # GET /posts/1/tags/1/new
  def new
    @post = Post.find(params[:post_id])

    # check if it tries to add the tag
    @add_tag = true

    # check for empty tag text
    if (params[:tag_text].blank?)
      @add_tag = false
    end

    # check for existing relationship
    if (@add_tag)
      @post.tags.each do |tag|
        if tag.tag_text == params[:tag_text]
          @add_tag = false
        end
      end
    end

    # check for existing tags
    if (@add_tag)
      @query_tags = Tag.where("tag_text = ?", params[:tag_text])

      # if tag does not exist on database, create it
      if @query_tags.size == 0
        @tag = Tag.new
        @tag.tag_text = params[:tag_text]
      else
        @tag = @query_tags.first
      end

      @post.tags << @tag
      @post.save
    end

    respond_to do |format|
      format.html { redirect_to @post }
      format.json { head :no_content }
      format.js { render :layout => false }
    end
  end

  # GET /tags/1/edit
  # GET /posts/1/tags/1/edit
  def edit

  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @post = Post.find(params[:post_id])

    # remove tag from post
    @post.tags = @post.tags.reject {|item| (item.id == params[:id].to_i)}

    @post.save

    respond_to do |format|
      format.html { redirect_to @post }
      format.json { head :no_content }
      format.js { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:tag_text)
    end
end
