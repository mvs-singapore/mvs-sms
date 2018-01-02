require 'rails_helper'

describe 'manage disabilities', type: :feature do
  let!(:teacher_role) { Role.create(name: 'teacher') }
  let!(:teacher_user) { User.create(email: 'yammy@example.com', password: 'password', name: 'Teacher Yammy', role: teacher_role) }
  let!(:default_disability) { Disability.create(title: 'Autistic') }

  let!(:garbage_collector) { Disability.create(title: 'garbage_collector') }

  before do
    sign_in teacher_user
    visit '/disabilities'
  end

  describe 'create disability' do
    it 'creates new disability' do
      click_link 'Add Disability'
      within('#new_disability') do
        fill_in 'Title', with: "Down's Syndrome"
      end

      click_button 'Create Disability'

      expect(page).to have_text 'Successfully created disability'
      expect(Disability.where(title: "Down's Syndrome").count).to eq 1
    end
  end

  describe 'edit disability' do
    it 'edits an existing disability' do
      within("#disability-#{default_disability.id}") do
        find_link('Autistic').click
      end

      within('.edit_disability') do
        fill_in 'Title', with: "Down's Syndrome"
      end
      click_button 'Update Disability'

      expect(page).to have_text 'Successfully updated disability'

      expect(default_disability.reload.title).to eq "Down's Syndrome"
    end
  end

  describe 'delete disability', js: true do
    it 'deletes an existing disability' do
      within("#disability-#{garbage_collector.id}") do
        accept_confirm_dialog {
          find_link('Delete', visible: true).click
        }
      end

      expect(page).to have_text 'Successfully deleted disability'
      expect(Disability.where(title: 'garbage_collector').count).to eq 0
    end
  end
end
