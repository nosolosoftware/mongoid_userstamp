# frozen_string_literal: true

require 'spec_helper'

describe Mongoid::Userstamp::User do
  subject(:book) { Book.new(name: 'Crafting Rails Applications') }
  subject(:post) { Post.new(title: 'Understanding Rails') }

  let(:user1) { User.create!(name: 'Charles Dikkens') }
  let(:user2) { User.create!(name: 'Edmund Wells') }
  let(:admin1) { Admin.create!(name: 'JK Rowling') }
  let(:admin2) { Admin.create!(name: 'Stephan Norway') }

  describe '::current_user and #current_user?' do
    before do
      Admin.current_user = nil
      User.current_user = nil
    end

    context 'when current_user users are not set' do
      it { expect(Admin.current_user).to be_nil }
      it { expect(User.current_user).to be_nil }
      it { expect(admin1.current_user?).to be_falsey }
      it { expect(admin2.current_user?).to be_falsey }
      it { expect(user1.current_user?).to be_falsey }
      it { expect(user2.current_user?).to be_falsey }
    end

    context 'when current_user User is set' do
      before { User.current_user = user1 }
      it { expect(User.current_user).to eq user1 }
      it { expect(Admin.current_user).to be_nil }
      it { expect(admin1.current_user?).to be_falsey }
      it { expect(admin2.current_user?).to be_falsey }
      it { expect(user1.current_user?).to be_truthy }
      it { expect(user2.current_user?).to be_falsey }
    end

    context 'when current_user Admin is set' do
      before { Admin.current_user = admin1 }
      it { expect(User.current_user).to be_nil }
      it { expect(Admin.current_user).to eq admin1 }
      it { expect(admin1.current_user?).to be_truthy }
      it { expect(admin2.current_user?).to be_falsey }
      it { expect(user1.current_user?).to be_falsey }
      it { expect(user2.current_user?).to be_falsey }
    end
  end

  describe '::do_as' do
    it 'should set the current_user user' do
      Admin.current_user = admin1
      Admin.do_as admin2 do
        Admin.current_user.should eq admin2
      end
      Admin.current_user.should eq admin1
    end

    it 'should return the value of the block' do
      Admin.do_as admin2 do
        'foo'
      end.should eq 'foo'
    end

    it 'should revert user in case of error' do
      Admin.current_user = admin1
      begin
        Admin.do_as admin2 do
          raise
        end
      rescue StandardError
        Admin.current_user.should eq admin1
      end
      Admin.current_user.should eq admin1
    end
  end

  describe '::userstamp_user' do
    before { User.instance_variable_set(:@_userstamp_user_config, nil) }

    context 'when options are not given' do
      subject { User.userstamp_user }
      it { is_expected.to be_a Mongoid::Userstamp::UserConfig }
      it { expect(subject.controller_current_user).to eq :current_user }
    end

    context 'when options are given' do
      subject { User.userstamp_user(controller_current_user: :foo) }
      it { is_expected.to be_a Mongoid::Userstamp::UserConfig }
      it { expect(subject.controller_current_user).to eq :foo }
    end

    context 'when userstamp_user has been set' do
      subject do
        User.userstamp_user
        User.userstamp_user(controller_current_user: :foo)
      end

      it { is_expected.to be_a Mongoid::Userstamp::UserConfig }
      it { expect(subject.controller_current_user).to eq :current_user }
    end
  end
end
