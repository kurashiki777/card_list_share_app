class CardsController < ApplicationController
    def index
      @cards = Card.all.includes(:user).order(created_at: :desc)
    end
end
