require 'rails_helper'

feature 'reviewing' do
  before {Restaurant.create name: 'KFC'}

  scenario 'allows users to leave a review using a form' do
    sign_up_and_in('user1@test.com')
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  def leave_review(thoughts, rating)
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: thoughts
    select rating, from: 'Rating'
    click_button 'Leave Review'
  end

  scenario 'displays an average rating for all reviews' do
    sign_up_and_in('user1@test.com')
    create_restaurant('KFC')
    leave_review('So so', '3')
    click_link 'Sign out'
    sign_up_and_in('user2@test.com')
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: 4')
  end
end
