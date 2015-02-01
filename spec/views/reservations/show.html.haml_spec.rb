require 'rails_helper'

RSpec.describe "reservations/show", :type => :view do
  before(:each) do
    @reservation = assign(:reservation, Reservation.create!(
      :table_number => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
  end
end
