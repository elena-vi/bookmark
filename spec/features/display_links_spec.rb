require 'spec_helper'

feature "displaying links" do
  scenario "list of links" do
    Link.create(url: 'http://www.google.com', title: 'google')
    visit ('/links')
    expect(page.status_code).to eq 200

    within 'ul#links' do
      expect(page).to have_content("google")
    end
  end
end
