require 'rails_helper'

RSpec.describe "reservations/index", :type => :view do
  before(:each) do
    assign(:reservations, [
      Reservation.create!(
        :table_number => 1
      ),
      Reservation.create!(
        :table_number => 1
      )
    ])
  end

  it "renders a list of reservations" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
