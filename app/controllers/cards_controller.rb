class CardsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]


  #GET /cards/search
  #GET /cards/search.xml
  def search
    @cards = Card.search do
      fulltext params[:query]
    end.results

    respond_to do |format|
      format.html { render :action => "index" }
      format.json { render json: @cards }
    end
  end


  # GET /cards
  # GET /cards.json
  def index
    @cards = Card.order("created_at desc")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cards }
    end
  end

  def favorite
    @cards = current_user.find_up_voted_items

    respond_to do |format|
      format.html { render :action => "index" }
      format.json { render json: @cards }
    end
  end


  # GET /cards/1
  # GET /cards/1.json
  def show
    @card = Card.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @card }
    end
  end

  # GET /cards/new
  # GET /cards/new.json
  def new
    @card = current_user.cards.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @card }
    end
  end

  # GET /cards/1/edit
  def edit
    @card = current_user.cards.find(params[:id])
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = current_user.cards.new(params[:card])

    respond_to do |format|
      if @card.save
        format.html { redirect_to @card, notice: 'Card was successfully created.' }
        format.json { render json: @card, status: :created, location: @card }
      else
        format.html { render action: "new" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cards/1
  # PUT /cards/1.json
  def update
    @card = current_user.cards.find(params[:id])

    respond_to do |format|
      if @card.update_attributes(params[:card])
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card = current_user.cards.find(params[:id])
    @card.destroy

    respond_to do |format|
      format.html { redirect_to cards_url }
      format.json { head :no_content }
    end
  end

  def upvote
    @card = current_user.cards.find(params[:id])
    @card.upvote_by current_user
    redirect_to :back
  end

  def downvote
    @card = current_user.cards.find(params[:id])
    @card.downvote_by current_user
    redirect_to :back
  end
end
