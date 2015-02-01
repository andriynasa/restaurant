json.array!(@reservations) do |reservation|
  json.extract! reservation, :id, :table_number, :start_at, :end_at
  json.url reservation_url(reservation, format: :json)
end
