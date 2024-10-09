require 'rails_helper'

RSpec.describe "industries/index", type: :view do
  before(:each) do
    assign(:industries, [
      Industry.create!(
        industry_type: "Industry Type"
      ),
      Industry.create!(
        industry_type: "Industry Type"
      )
    ])
  end

  it "renders a list of industries" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Industry Type".to_s), count: 2
  end
end
