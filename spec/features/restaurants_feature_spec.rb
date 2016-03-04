require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      sign_up_and_in('user1@test.com')
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end


  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
      sign_up_and_in('user1@test.com')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      sign_up_and_in('user1@test.com')
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'an invalid restaurants' do
    it 'does not let you submit a name thats is too short' do
      sign_up_and_in('user1@test.com')
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Kf'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text:'kf'
      expect(page).to have_content 'error'
    end
  end

  context 'viewing Restaurants' do
    let!(:kfc) { Restaurant.create(name:'KFC')}

    scenario 'lets a user view a restaurant' do
      sign_up_and_in('user1@test.com')
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do

    scenario 'let a user edit a restaurant' do
      sign_up_and_in('user1@test.com')
      create_restaurant('KFC')
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'deleting restaurants' do

    scenario 'removes a restaurant when a user clicks a delete link' do
      sign_up_and_in('user1@test.com')
      create_restaurant('KFC')
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'removes a restaurant and deletes associated reviews' do
      sign_up_and_in('user1@test.com')
      create_restaurant('KFC')
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content('so so')
      click_link 'Delete KFC'
      expect(page).not_to have_content('KFC')
    end
  end
end
