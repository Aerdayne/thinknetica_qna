import consumer from "./consumer"

consumer.subscriptions.create('AnswersChannel', {
  connected() {
    var route = window.location.href.split('/').slice(-2);
    if ((route[0] = 'questions') && (route[1].match(/\d/))) {
      this.perform('follow', { id: route[1] });
    }
  },
  disconnected() {},
  received(data) {
    var answers = $('.answers');
    if ((answers) && (data['answer']['user_id'] != gon.current_user)) {
      var answer = renderAnswer(data['answer'], data['question_author_id']);
      var div = document.createElement('div');
      div.setAttribute('data-id', data['answer']['id']);
      div.classList.add('answer');
      div.innerHTML = answer;
      answers.append(div);  
    }
  },
});

function renderAnswer(answer, question_author_id) {
  var element = `
    <hr>
  `;

  if (answer['user_id'] != gon.current_user) {
    var votes = `
      <a data-type="json" style="font-size:2.0em; text-decoration:none;" class="upvote" data-remote="true" rel="nofollow" data-method="post" href="/answers/${answer['id']}/upvote">▲</a>
      <a data-type="json" style="font-size:2.0em; text-decoration:none;" class="downvote" data-remote="true" rel="nofollow" data-method="post" href="/answers/${answer['id']}/downvote">▼</a>
    `;
    element += votes;
  };

  element += `
    <p class="score">${answer['score']}</p>
    <h4>${answer['body']}</h4>
  `;

  if (question_author_id == gon.current_user) {
    var setBestButton = `
      <a data-remote="true" class="btn btn-primary" rel="nofollow" data-method="patch" href="/answers/${answer['id']}/set_best">Mark as best</a>
    `;
    element += setBestButton;
  };

  if (answer['user_id'] == gon.current_user) {
    var buttons = `
      <a data-answer-id="${answer['id']}" data-remote="true" class="delete-answer-link btn btn-primary" rel="nofollow" data-method="delete" href="/answers/${answer['id']}">Delete</a>
      <a data-answer-id="${answer['id']}" class="edit-answer-link btn btn-primary" href="#">Edit</a>
    `;
    element += buttons;
  };

  var form = `
    <form class="hidden" id="edit-answer-${answer['id']}" enctype="multipart/form-data" action="/answers/${answer['id']}" accept-charset="UTF-8" data-remote="true" method="post">
      <input type="hidden" name="_method" value="patch">
      <input type="hidden" name="authenticity_token" value="VBZCR/Mbau2Bw7kNG1xdfusl+mtLc6YIMYQUQZ3azi65j2+W8Y8Qf6aPF2vpz4G8haVTCJRWuo9h/mOguckoaQ==">
      <div class="form-group">
        <label for="answer_body">Your answer</label>
        <textarea class="form-control" name="answer[body]" id="answer_body">${answer['body']}</textarea>
      </div>
      <div class="form-group">
        <label for="answer_files">Attach files:</label>
        <input multiple="multiple" class="form-control" data-direct-upload-url="http://localhost:3000/rails/active_storage/direct_uploads" type="file" name="answer[files][]" id="answer_files">
      </div>
      <div class="form-group">
        <div class="answer-links">
          <a class="add_fields" data-association="link" data-associations="links" data-association-insertion-template="<div class=&quot;nested-fields&quot;><div class=&quot;field&quot;><label for=&quot;answer_links_attributes_new_links_name&quot;>Link name</label><input type=&quot;text&quot; name=&quot;answer[links_attributes][new_links][name]&quot; id=&quot;answer_links_attributes_new_links_name&quot; /></div><div class=&quot;field&quot;><label for=&quot;answer_links_attributes_new_links_url&quot;>Url</label><input type=&quot;text&quot; name=&quot;answer[links_attributes][new_links][url]&quot; id=&quot;answer_links_attributes_new_links_url&quot; /></div><input value=&quot;false&quot; type=&quot;hidden&quot; name=&quot;answer[links_attributes][new_links][_destroy]&quot; id=&quot;answer_links_attributes_new_links__destroy&quot; /><a class=&quot;remove_fields dynamic&quot; href=&quot;#&quot;>Remove link</a></div>" href="#">Add link</a>
        </div>
      </div>
      <input type="submit" name="commit" value="Save" class="btn btn-primary" data-disable-with="Save">
    </form>
  </div>
  `;

  element += form;

  var comments = `
    <div class="comments">
      <h4>Comments:</h4>
    </div>
  `;

  element += comments;

  if (gon.current_user) {
    var commentForm = `
      <form class="comment-form" action="/answers/${answer['id']}/comments" accept-charset="UTF-8" data-remote="true" method="post">
        <input type="hidden" name="authenticity_token" value="xKTOaPtZTSsA9sxVMOxyYzkjO2qZaDtIdGX61vu1zzxJWgqhTwiTiXv1C1G7c2ZlSgco4ZyInPane5vWCIBCuA==">
        <div class="form-group">
          <label for="comment_content">Your comment</label>
          <input class="form-control" type="text" name="comment[content]" id="comment_content">
        </div>
        <input type="submit" name="commit" value="Comment" class="btn btn-primary" data-disable-with="Comment">
      </form>
    `;
    element += commentForm;
  };

  return element;
};