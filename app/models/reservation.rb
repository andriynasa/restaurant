class Reservation < ActiveRecord::Base

# Validations =================================================================
	validates_presence_of :table_number, :name, :phone, 
		:start_at_time, :start_at_date, :end_at_time
	validates_numericality_of :table_number, only_integer: true
	validates :table_number, inclusion: 1..12
	validates :start_at, :end_at, overlap: {scope: "table_number"}
	validate :datetime_interval
# Callbacks ===================================================================
	before_validation :convert_to_datetime
# Scopes ======================================================================
	scope :active, -> { where( 'start_at >= ?', DateTime.now.beginning_of_day )}
# Instance methods ============================================================
	# add virtual attributes :(
	def start_at_date
	  start_at.strftime("%Y-%m-%d") if start_at.present?
	end 

	def start_at_time
	  start_at.strftime("%H:%M") if start_at.present?
	end

	def end_at_time
		end_at.strftime("%H:%M") if end_at.present?
	end

	def start_at_date= date
		return unless date.present?
	  @start_at_date = Date.parse(date).strftime("%Y-%m-%d")
	end
	def start_at_time= time
		return unless time.present?
	  @start_at_time = Time.parse(time).strftime("%H:%M")
	end

	def end_at_time= time
		return unless time.present?
		@end_at_time = Time.parse(time).strftime("%H:%M")
	end

	def convert_to_datetime
		return nil unless (@start_at_date || @start_at_time || @end_at_time)
 	  self.start_at = DateTime.parse("#{@start_at_date} #{@start_at_time}")
	  self.end_at = DateTime.parse("#{@start_at_date} #{@end_at_time}")
	end

	def datetime_interval
		return nil unless self.start_at || self.end_at
		if self.start_at > self.end_at
			errors.add :end_at, I18n.t("errors.date_interval_error")
		end
	end
end
