require 'rails_helper'

feature "User can sign in and out" do
  context "user not signed in and on the homepage" do
    it "should see a 'sign in' link and a 'sign up' link" do
      visit('/')
      expect(page).to have_link('Sign in')
      expect(page).to have_link('Sign up')

    end

    it "should not see 'sign out' link" do
      visit('/')
      expect(page).not_to have_link('Sign out')
    end
  end

  context "user signed in on the homepage" do
    before do
      sign_up_and_in('user1@test.com')
    end

    it "should see 'sign out' link" do
      visit('/')
      expect(page).to have_link('Sign out')
    end

    it "should not see a 'sign in' link and a 'sign up' link" do
      visit('/')
      expect(page).not_to have_link('Sign in')
      expect(page).not_to have_link('Sign up')
    end
  end

  context "unless logged in" do
    it "should not be able to create a new restaurant" do
      visit('/')
      expect(page).not_to have_link('Add a restaurant')
    end
  end
end

feature "Users can only edit/delete restaurants which they've created" do
  context "whilst logged in" do
    it "cannot edit/delete another user's created restaurant" do
      sign_up_and_in('user1@test.com')
      create_restaurant('Pizza Planet')
      click_link('Sign out')
      sign_up_and_in('user2@test.com')
      expect(page).not_to have_link('Edit Pizza Planet')
      expect(page).not_to have_link('Delete Pizza Planet')
    end
  end
end

feature "Users can only add one review per restaurant" do
  context "whilst logged in" do
    it "cannot add more than one review for a single restaurant" do
      sign_up_and_in('user1@test.com')
      create_restaurant('Pizza Planet')
      create_review('Pizza Planet', 'Mmm...delicious pizza!', '5')
      expect(page).not_to have_link('Review Pizza Planet')
    end
  end
end

feature "Users can only delete their own reviews" do
  context "whilst logged in" do
    it "can only delete their own review" do
      sign_up_and_in('user1@test.com')
      create_restaurant('Pizza Planet')
      create_review('Pizza Planet', 'Mmm...delicious pizza!', '5')
      click_link('Delete Pizza Planet Review')
      expect(page).not_to have_content('Mmm...delicious pizza!')
    end
    it "can't delete other user's reviews" do
      sign_up_and_in('user1@test.com')
      create_restaurant('Pizza Planet')
      create_review('Pizza Planet', 'Mmm...delicious pizza!', '5')
      click_link('Sign out')
      sign_up_and_in('user2@test.com')
      expect(page).not_to have_link('Delete Pizza Planet Review')
    end

  end
end
