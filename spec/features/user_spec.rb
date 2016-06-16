def sign_up
	visit '/user/new'
	fill_in 'email', with: 'email@mail.com'
	fill_in 'password', with: 'super secret'
	click_button 'Sign up'
end

feature 'user sign up' do

	scenario 'Incriment users by 1' do

		expect { sign_up }.to change(User, :count).by(1)

		expect(page).to have_content 'Welcome email@mail.com'
	end

end
