import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {},

  disconnected() {},

  received(data) {
    var questionsTable = $('.questions');
    if (questionsTable) {
      var tr = document.createElement('tr');
      var td1 = document.createElement('td');
      var td2 = document.createElement('td');
      td1.innerHTML = parseInt($('tr').last().find('td:first')[0].innerHTML) + 1;
      td2.innerHTML = '<a href="/questions/' + data['locals']['question']['id'] + '">' + data['locals']['question']['title'] + '</a>';
      tr.append(td1);
      tr.append(td2);
      questionsTable.append(tr);
    }
  },
});
