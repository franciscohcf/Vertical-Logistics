require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Schema' do
    it 'has custom primary key user_id' do
      expect(User.primary_key).to eq('user_id')
    end
  end

  describe 'Validations' do
    context 'when it is valid' do
      it 'has user_id and name' do
        user = User.new(user_id: 1, name: 'Paulo')

        expect(user).to be_valid
      end
    end

    context 'when it is invalid' do
      it 'without a user_id' do
        user = User.new(name: 'Paulo')
        user.valid?

        expect(user.errors[:user_id]).to include("can't be blank")
      end

      it 'without a name' do
        user = User.new(user_id: 1)
        user.valid?

        expect(user.errors[:name]).to include("can't be blank")
      end

      it 'with a duplicate user_id' do
        User.create!(user_id: 1, name: 'Paulo')

        duplicate_user = User.new(user_id: 1, name: 'Joao')
        duplicate_user.valid?

        expect(duplicate_user.errors[:user_id]).to include('has already been taken')
      end
    end
  end

  describe 'Associations' do
    it 'has many orders' do
      association = User.reflect_on_association(:orders)

      expect(association.macro).to eq(:has_many)
    end
  end
end
