import consumer from "./consumer"

consumer.subscriptions.create('CommentsChannel', {
  connected() {
    var route = window.location.href.split('/').slice(-2);
    if ((route[0] = 'questions') && (route[1].match(/\d/))) {
      this.perform('follow', { id: route[1] });
    }
  },
  received(data) {
    var resource_type = data['resource_type'];

    if (resource_type == 'Question') {
      var resource = $('.question .comments');
    }
    else if (resource_type == 'Answer') {
      var resource = $('.answers div[data-id=' + data['resource_id'] + '] .comments');
    };

    console.log(resource)
    if ((resource) && (data['comment']['user_id'] != gon.current_user)) {
      var comment = renderComment(data['comment'], data['user_email']);
      resource.append(comment);
    };
  },
});

function renderComment(comment, user_email) {
  var element = `
  <div class="comment" data-id="${comment['id']}">
    <hr>
    <p>${user_email} says:</p>
    <p>${comment['content']}</p> 
  `;
  
  if (gon.current_user == comment['user_id']) {
    element += `<a data-comment-id="${comment['id']}" data-remote="true" class="delete-answer-link btn btn-primary" rel="nofollow" data-method="delete" href="/comments/${comment['id']}">Delete</a>`
  };
  
  element += '</div>'
  return element;
};