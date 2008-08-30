class Event < ActiveRecord::Base
  has_many :attendees

  named_scope :upcomings, lambda {
    {:conditions => ["force_disabled = ? and publish_at <= ? and scheduled_on > ?",
        false, DateTime.now, Date.today],
      :order => "scheduled_on DESC"}
  }
  named_scope :archives, lambda {
    {:conditions => ["force_disabled = ? and publish_at <= ? and scheduled_on < ?",
        false, DateTime.now, Date.today],
     :order => "scheduled_on"}
  }

# TODO validations
  validates_uniqueness_of :name

  def registration_enabled?
    under_capacity? && !expired?
  end

  def under_capacity?
    attendees_count < capacity
  end

  def expired?
    scheduled_on < Date.today
  end

  def published?
    publish_at <= DateTime.now
  end

  private
  def attendees_count
    attendees.count
  end
end
