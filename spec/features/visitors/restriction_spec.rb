require 'spec_helper'
require 'rails_helper'

RSpec.describe 'As a visitor I cannot visit' do
  it '/admin routes' do
    visit admin_dashboard_path
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end
  
  it '/merchant routes' do
    visit merchant_dashboard_path
    expect(page).to have_content("The page you were looking for doesn't exist (404)")
  end

end
