
feature 'User tests' do
	scenario 'can sign up' do
		sign_up
		expect(User.first.email).to eq('batman@gotham.com')
	end

	scenario 'sign_up with wrong confirmed password' do
		expect{sign_up(password_confirmation: "Enter Password")}.not_to change(User, :count)
		expect(page).to have_content 'Password and confirmation password do not match'
		expect(page).to have_current_path('/user/new')
	end
end
