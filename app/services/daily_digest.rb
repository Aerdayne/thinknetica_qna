class DailyDigest
  def send_digest
    form_report
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, @questions).deliver_later
    end
  end

  private

  def form_report
    @questions = Question.where("created_at > ?", 1.day.ago)
  end
end