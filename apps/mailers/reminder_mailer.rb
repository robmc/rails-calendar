class ReminderMailer < ActionMailer::Base
  default :from => "from@example.com"

  def event_reminder(event)
    @event = event

    mail(:to => event.user.email, :subject => "Reminder of your event").deliver
  end
end