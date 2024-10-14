require 'rails_helper'

RSpec.describe 'industries/edit', type: :view do
  let(:industry) do
    Industry.create!(
      industry_type: 'MyString'
    )
  end

  before(:each) do
    assign(:industry, industry)
  end

  it 'renders the edit industry form' do
    render

    assert_select 'form[action=?][method=?]', industry_path(industry), 'post' do
      assert_select 'input[name=?]', 'industry[industry_type]'
    end
  end
end
