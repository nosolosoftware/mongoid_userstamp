# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Mongoid::Userstamp::User do

  subject(:book) { Book.new(name: 'Crafting Rails Applications') }
  subject(:post) { Post.new(title: 'Understanding Rails') }

  let(:user_1) { User.create!(name: 'Charles Dikkens') }
  let(:user_2) { User.create!(name: 'Edmund Wells') }
  let(:admin_1) { Admin.create!(name: 'JK Rowling') }
  let(:admin_2) { Admin.create!(name: 'Stephan Norway') }

  describe '::current and #current?' do
    before { Admin.current = nil; User.current = nil }

    context 'when current users are not set' do
      it { Admin.current.should be_nil }
      it { User.current.should be_nil }
      it { admin_1.current?.should be_falsey }
      it { admin_2.current?.should be_falsey }
      it { user_1.current?.should be_falsey }
      it { user_2.current?.should be_falsey }
    end

    context 'when current User is set' do
      before{ User.current = user_1 }
      it { User.current.should eq user_1 }
      it { Admin.current.should be_nil }
      it { admin_1.current?.should be_falsey }
      it { admin_2.current?.should be_falsey }
      it { user_1.current?.should be_truthy }
      it { user_2.current?.should be_falsey }
    end

    context 'when current Admin is set' do
      before{ Admin.current = admin_1 }
      it { User.current.should be_nil }
      it { Admin.current.should eq admin_1 }
      it { admin_1.current?.should be_truthy }
      it { admin_2.current?.should be_falsey }
      it { user_1.current?.should be_falsey }
      it { user_2.current?.should be_falsey }
    end
  end

  describe '::do_as' do
    it 'should set the current user' do
      Admin.current = admin_1
      Admin.do_as admin_2 do
        Admin.current.should eq admin_2
      end
      Admin.current.should eq admin_1
    end

    it 'should return the value of the block' do
      Admin.do_as admin_2 do
        'foo'
      end.should eq 'foo'
    end

    it 'should revert user in case of error' do
      Admin.current = admin_1
      begin
        Admin.do_as admin_2 do
          raise
        end
      rescue
      end
      Admin.current.should eq admin_1
    end
  end

  describe '::mongoid_userstamp_user' do
    before{ User.instance_variable_set(:'@mongoid_userstamp_user', nil) }

    context 'when options are not given' do
      subject{ User.mongoid_userstamp_user }
      it { should be_a Mongoid::Userstamp::UserConfig }
      it { subject.reader.should eq :current_user  }
    end

    context 'when options are given' do
      subject{ User.mongoid_userstamp_user(reader: :foo) }
      it { should be_a Mongoid::Userstamp::UserConfig }
      it { subject.reader.should eq :foo  }
    end

    context 'when mongoid_userstamp_user has been set' do
      subject{ User.mongoid_userstamp_user; User.mongoid_userstamp_user(reader: :foo) }
      it { should be_a Mongoid::Userstamp::UserConfig }
      it { subject.reader.should eq :current_user  }
    end
  end
end
