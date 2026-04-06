class Event < ActiveRecord::Base
  
  has_event_calendar
  belongs_to :user
  
  attr_accessible :name, :start_at, :end_at, :attachments_attributes, :user_id, :periodicity, :frequency, :all_day, :reminder_at_event_start,
  :reminder_15_mins_before, :reminder_30_mins_before, :reminder_1_hr_before, :reminder_1_day_before, :todos_attributes, :media, :description
  has_many :attachments
  has_many :todos
  accepts_nested_attributes_for :attachments, allow_destroy: true
  accepts_nested_attributes_for :todos, allow_destroy: true
  
  validate :validate_attachments
  validate :validate_end_date_after_start_date
  validate :validate_number_of_todos
  validates_presence_of :name, :start_at, :end_at
  validates_length_of :name, :maximum => 100
  validates_length_of :description, :maximum => 2000, :allow_blank => true
  validates_numericality_of :frequency, :only_integer => true , :greater_than_or_equal_to => 1
  
  after_save :recurrent_events
  after_save :reminder_at_time_of_event
  after_save :reminder_15_mins_before_event
  after_save :reminder_30_mins_before_event
  after_save :reminder_1_hour_before_event
  after_save :reminder_1_day_before_event

  Max_Attachments = 5
  Max_Attachment_Size = 5.megabytes
  
  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def self.report(report_start, report_end)
    where(:start_at => report_start..report_end)
  end
  
  def validate_attachments
    errors.add_to_base("Too many attachments - maximum is #{Max_Attachments}") if attachments.length > Max_Attachments
    attachments.each {|a| errors.add_to_base("#{a.attachment_file_name} is over #{Max_Attachment_Size/1.megabytes}MB") if a.attachment_file_size > Max_Attachment_Size}
  end

  def recurrent_events
    # 0 - Single event
    if periodicity == 0
    # 1 - Every year
    elsif periodicity == 1
      i = 1
      until i >= frequency
        ev = Event.new(:name => name, :start_at => start_at + i.year,
                                      :end_at => end_at + i.year,
                                      :user_id => user_id, :frequency => 1)
        i += 1
        ev.save!
      end
    # 2 - Every month
    elsif periodicity == 2
      i = 1
      until i >= frequency
        ev = Event.new(:name => name, :start_at => start_at + i.month,
                                      :end_at => end_at + i.month,
                                      :user_id => user_id, :frequency => 1)
        i += 1
        ev.save!
      end
    # 3 - Every week
    elsif periodicity == 3
      i = 1
      until i >= frequency
        ev = Event.new(:name => name, :start_at => start_at + i.week,
                                      :end_at => end_at + i.week,
                                      :user_id => user_id, :frequency => 1)
        i += 1
        ev.save!
      end
    # 4 - Every day
    elsif periodicity == 4
      i = 1
      until i >= frequency
        ev = Event.new(:name => name, :start_at => start_at + i.day,
                                      :end_at => end_at + i.day,
                                      :user_id => user_id, :frequency => 1)
        i += 1
        ev.save!
      end
    end
  end
  
  def validate_end_date_after_start_date
    if start_at && end_at
      errors.add("", "Start date must be before end date.") if end_at < start_at
    end
  end
  
  def reminder_at_time_of_event
    if self.reminder_at_event_start == true
      ReminderMailer.delay(:run_at => (self.start_at).in_time_zone).event_reminder(self)
    end
  end
  
  def reminder_15_mins_before_event
    if self.reminder_15_mins_before == true
      ReminderMailer.delay(:run_at => (self.start_at).in_time_zone - 15.minutes).event_reminder(self)
    end
  end
  
  def reminder_30_mins_before_event
    if self.reminder_30_mins_before == true
      ReminderMailer.delay(:run_at => (self.start_at).in_time_zone - 30.minutes).event_reminder(self)
    end
  end
  
  def reminder_1_hour_before_event
    if self.reminder_1_hr_before == true
      ReminderMailer.delay(:run_at => (self.start_at).in_time_zone - 60.minutes).event_reminder(self)
    end
  end
  
  def reminder_1_day_before_event
    if self.reminder_1_day_before == true
      ReminderMailer.delay(:run_at => (self.start_at).in_time_zone - 1440.minutes).event_reminder(self)
    end
  end
  
  def as_json(options={})
     { :startDate => self.start_at.strftime("%Y,%m,%d"),
       :endDate => self.end_at.strftime("%Y,%m,%d"),
       :headline => "<a href =\"/events/#{self.id}\">#{self.name}</a>",
       :text => self.description,
       :asset => {
         :media => self.media,
       }
     }
  end
  
  def validate_number_of_todos
      errors.add(:todos, "Cannot have more than 10 ToDos") if todos.length > 10
  end

end
