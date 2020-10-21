require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'バリデーション' do
    it 'emailが空でもOK' do
      @user.email = ''
      expect(@user.valid?).to eq(true)
    end
  end
end
