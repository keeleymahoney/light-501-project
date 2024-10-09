require 'rails_helper'

RSpec.describe "contacts_industries/index", type: :view do
  before(:each) do
    assign(:contacts_industries, [
      ContactsIndustry.create!(),
      ContactsIndustry.create!()
    ])
  end

  it "renders a list of contacts_industries" do
    render
    cell_selector = 'div>p'
  end
end
