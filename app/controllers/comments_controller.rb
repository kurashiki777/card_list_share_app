class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
        redirect_to card_path(comment.card), success: t('defaults.message.created', item: Comment.model_name.human)
    else
        redirect_to card_path(comment.card), danger: t('defaults.message.not_created', item: Comment.model_name.human)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(card_id: params[:card_id])
  end
end
