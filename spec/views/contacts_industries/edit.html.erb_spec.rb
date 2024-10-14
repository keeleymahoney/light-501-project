require 'rails_helper'

RSpec.describe 'contacts_industries/edit', type: :view do
  let(:contacts_industry) do
    ContactsIndustry.create!
  end

  before(:each) do
    assign(:contacts_industry, contacts_industry)
  end

  it 'renders the edit contacts_industry form' do
    render

    assert_select 'form[action=?][method=?]', contacts_industry_path(contacts_industry), 'post' do
    end
  end
end
