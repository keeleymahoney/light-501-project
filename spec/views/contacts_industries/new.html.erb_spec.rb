require 'rails_helper'

RSpec.describe 'contacts_industries/new', type: :view do
  before(:each) do
    assign(:contacts_industry, ContactsIndustry.new)
  end

  it 'renders new contacts_industry form' do
    render

    assert_select 'form[action=?][method=?]', contacts_industries_path, 'post' do
    end
  end
end
