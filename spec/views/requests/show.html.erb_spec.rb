require 'rails_helper'

RSpec.describe 'requests/show', type: :view do
  before(:each) do
    assign(:request, Request.create!(
                       status: false
                     ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/false/)
  end
end
