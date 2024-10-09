require 'rails_helper'

RSpec.describe "contacts_industries/show", type: :view do
  before(:each) do
    assign(:contacts_industry, ContactsIndustry.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
