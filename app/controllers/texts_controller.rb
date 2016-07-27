require 'twilioapi'

class TextsController < ApplicationController
  def send_text
    @task = Task.find(params[:task_id])
    if send_reminder(@task)
      flash[:success] = "A reminder was sent to your phone number."
    else
      flash[:error] = "Your phone number was wrong or something."
    end
    redirect_to @task
  end

  private

  def send_reminder(task)
    client = TwilioAPI.new
    client.text("Reminder!\n#{task.description} due on #{task.due_date.in_time_zone("Pacific Time (US & Canada)").to_s(:rfc822)}")
  end
end
