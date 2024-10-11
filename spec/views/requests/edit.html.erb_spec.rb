require 'rails_helper'

RSpec.describe "requests/edit", type: :view do
  let(:request) {
    Request.create!(
      status: false
    )
  }

  before(:each) do
    assign(:request, request)
  end

  it "renders the edit request form" do
    render

    assert_select "form[action=?][method=?]", request_path(request), "post" do

      assert_select "input[name=?]", "request[status]"
    end
  end
end
