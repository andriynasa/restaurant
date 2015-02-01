module ReservationsHelper
	def h_date date
		if date.to_date == Date.today
			date.strftime("%H:%M")
		else
			date.strftime("%F %R")
		end
	end
end
