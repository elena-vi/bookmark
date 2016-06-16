def sign_up(email: 'email@mail.com', password: 'super secret', password_confirmation: 'super secret' )
	visit '/user/new'
	fill_in 'email', with: email
	fill_in 'password', with: password
	fill_in 'password_confirmation', with: password_confirmation
	click_button 'Sign up'
end

feature 'user sign up' do

	scenario 'Incriment users by 1' do

		expect { sign_up }.to change(User, :count).by(1)

		expect(page).to have_content 'Welcome email@mail.com'
	end

	scenario 'Passwords dont match' do
		expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
		expect(current_path).to eq("/user")
		expect(page).to have_content "Password and confirmation password do not match"
	end

	scenario "nil email address" do
    expect { sign_up(email: nil) }.not_to change(User, :count)
  end

	scenario "invalid address" do
		expect { sign_up(email: "elena") }.not_to change(User, :count)
	end

	
end
