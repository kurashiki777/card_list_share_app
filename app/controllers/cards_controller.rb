class CardsController < ApplicationController
  def index
    @cards = current_user.cards.includes(:user).order(created_at: :desc)
  end

  def new
    @card = Card.new
  end
  
  def create
    # binding.pry
    @card = current_user.cards.build(card_params)
    if @card.save
        redirect_to cards_path, success: t('defaults.message.created', item: Card.model_name.human)
    else
        flash.now['danger'] = t('defaults.message.not_created', item: Card.model_name.human)
        render :new
    end
  end

  def show
    @card = Card.find(params[:id])
    @comment = Comment.new
    @comments = @card.comments.includes(:user).order(created_at: :desc)
  end

  def edit
    @card = current_user.cards.find(params[:id])
  end

  def update
    @card = current_user.cards.find(params[:id])
    if @card.update(card_params)
      redirect_to @card, success: t('defaults.message.updated', item: Card.model_name.human)
    else
      flash.now['danger'] = t('defaults.message.not_updated', item: Card.model_name.human)
      render :edit
    end
  end

  def destroy
    @card = current_user.cards.find(params[:id])
    @card.destroy!
    redirect_to cards_path, success: t('defaults.message.deleted', item: Card.model_name.human)
  end

    private

  def card_params
    params.require(:card).permit(:name, :remarks, :target_quantity, :stock_quantity, :card_image, :card_image_cache)
  end
end
