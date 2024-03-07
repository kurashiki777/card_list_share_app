import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if (data.action === 'create') {
      const comments = document.getElementById('comments');
      comments.insertAdjacentHTML('afterbegin', data.html);
    } else if (data.action === 'update') {
      const commentElement = document.getElementById(`comment-${data.comment.id}`);
      if (commentElement) {
        commentElement.innerHTML = data.html;
      }
    } else if (data.action === 'destroy') {
      const commentElement = document.getElementById(`comment-${data.comment.id}`);
      if (commentElement) {
        commentElement.remove();
      }
    }
  }
});
