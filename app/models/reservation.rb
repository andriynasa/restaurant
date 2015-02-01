class Reservation < ActiveRecord::Base

# Validations =================================================================
	validates_presence_of :table_number, :start_at, :end_at, :name, :phone
	validates_numericality_of :table_number, only_integer: true
	validates :table_number, inclusion: 1..10
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
	  @start_at_date = Date.parse(date).strftime("%Y-%m-%d")
	end

	def start_at_time= time
	  @start_at_time = Time.parse(time).strftime("%H:%M")
	end

	def end_at_time= time
		@end_at_time = Time.parse(time).strftime("%H:%M")
	end

	def convert_to_datetime
	  self.start_at = DateTime.parse("#{@start_at_date} #{@start_at_time}")
	  self.end_at = DateTime.parse("#{@start_at_date} #{@end_at_time}")
	end

	def datetime_interval
		if self.start_at > self.end_at
			errors.add :end_at, I18n.t("errors.date_interval_error")
		end
	end
end
