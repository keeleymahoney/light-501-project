require 'rails_helper'

RSpec.describe "requests/index", type: :view do
  before(:each) do
    assign(:requests, [
      Request.create!(
        status: false
      ),
      Request.create!(
        status: false
      )
    ])
  end

  it "renders a list of requests" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
