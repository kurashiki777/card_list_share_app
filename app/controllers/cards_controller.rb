class CardsController < ApplicationController
    def index
      @cards = Card.all.includes(:user).order(created_at: :desc)
    end

    def new
      @card = Card.new
    end
    
    def create
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
    end

    private

    def board_params
    params.require(:card).permit(:name, :remarks, :target_quantity)
    end
end
