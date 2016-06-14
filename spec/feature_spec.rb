feature 'Viewing links' do

  scenario 'to view saved links' do
    Link.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')
    visit '/links'
    expect(page.status_code).to eq 200
    within 'ul#links' do
      expect(page).to have_content('Makers Academy')
    end
  end
end

feature 'Adding links' do

  scenario 'to add new link to list' do
    visit '/links/new'

    fill_in :url, with: 'http://www.google.com'
    fill_in :title, with: 'Google Search'
    click_button 'Add Bookmark'

    within 'ul#links' do
      expect(page).to have_content('Google Search')
    end
  end
end

feature 'Adding links with a tag' do

  scenario 'to add new link to list' do
    visit '/links/new'

    fill_in :url, with: 'http://www.buzzfeed.com'
    fill_in :title, with: 'Buzzfeed'
    fill_in :tags, with: 'news'

    click_button 'Add Bookmark'

    link = Link.first
    expect(link.tags.map(&:name)).to include('news')
  end
end

feature 'Viewing links' do

  before(:each) do
    Link.create(url: 'http://www.makersacademy.com', title: 'Makers Academy', tags: [Tag.first_or_create(name: 'education')])
    Link.create(url: 'http://www.google.com', title: 'Google', tags: [Tag.first_or_create(name: 'search')])
    Link.create(url: 'http://www.zombo.com', title: 'This is Zombocom', tags: [Tag.first_or_create(name: 'bubbles')])
    Link.create(url: 'http://www.bubble-bobble.com', title: 'Bubble Bobble', tags: [Tag.first_or_create(name: 'bubbles')])
  end

  scenario 'filter links by tag' do
    visit '/tags/bubbles'

    expect(page.status_code).to eq(200)
    within 'ul#links' do
      expect(page).not_to have_content('Makers Academy')
      expect(page).not_to have_content('Code.org')
      expect(page).to have_content('This is Zombocom')
      expect(page).to have_content('Bubble Bobble')
    end
  end
end

feature 'multiple tags' do
  scenario 'I can add multiple tags to a new link' do
    visit '/links/new'
    fill_in 'url',   with: 'http://www.makersacademy.com/'
    fill_in 'title', with: 'Makers Academy'
    fill_in 'tags',  with: 'education ruby'
    click_button 'Add Bookmark'
    link = Link.first

    expect(link.tags.map(&:name)).to include('education', 'ruby')
  end
end

