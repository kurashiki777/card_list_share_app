class CommentBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment)
    # ActionCable を介してコメントをブロードキャストする
    ActionCable.server.broadcast 'comments_channel', comment: render_comment(comment)
  end

  private

  # コメントオブジェクトをレンダリングするためのヘルパーメソッド
  def render_comment(comment)
    # コメントの部分テンプレートをレンダリング
    ApplicationController.renderer.render(partial: 'comments/comment', locals: { comment: comment })
  end
end
