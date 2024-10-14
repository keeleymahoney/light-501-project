require 'rails_helper'

RSpec.describe 'industries/show', type: :view do
  before(:each) do
    assign(:industry, Industry.create!(
                        industry_type: 'Industry Type'
                      ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Industry Type/)
  end
end
