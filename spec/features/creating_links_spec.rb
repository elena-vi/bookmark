require 'spec_helper'

feature "add link" do
  scenario "adding a new link" do
    visit('links/new')
    fill_in :url, with: "https://www.apoorva.com"
    fill_in :title, with: "apoorva"
    click_button "Add New Link"
    expect(current_path).to eq "/links"

    within "ul#links" do
     expect(page).to have_content("apoorva")
   end
  end
end
