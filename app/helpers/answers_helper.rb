module AnswersHelper
  def best_mark(answer)
    if answer.best?
      "★ #{answer.body}"
    else
      answer.body
    end
  end
end
