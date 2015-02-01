require 'rails_helper'

RSpec.describe "reservations/edit", :type => :view do
  before(:each) do
    @reservation = assign(:reservation, Reservation.create!(
      :table_number => 1
    ))
  end

  it "renders the edit reservation form" do
    render

    assert_select "form[action=?][method=?]", reservation_path(@reservation), "post" do

      assert_select "input#reservation_table_number[name=?]", "reservation[table_number]"
    end
  end
end
