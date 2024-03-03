class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
        redirect_to card_path(comment.card), success: t('defaults.message.created', item: Comment.model_name.human)
    else
        redirect_to card_path(comment.card), danger: t('defaults.message.not_created', item: Comment.model_name.human)
    end
  end

  def edit
    @card = Card.find(params[:card_id])
    @comment = @card.comments.find(params[:id])
  end

  def update
    # binding.pry
    if @comment.update(comment_params)
      redirect_to card_path(@comment.card), notice: 'コメントを更新しました。'
    else
      puts @comment.errors.full_messages
      redirect_to edit_comment_path(@comment)
    end
  end

  def destroy
    @comment.destroy
    redirect_to card_url(@comment.card), notice: 'コメントを削除しました。'
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(card_id: params[:card_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
