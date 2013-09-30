# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Mongoid::Userstamp do
  subject { Book.new(name: 'Crafting Rails Applications') }
  let(:user_1) { User.create!(name: 'Charles Dikkens') }
  let(:user_2) { User.create!(name: 'Edmund Wells') }

  it { should respond_to :created_by }
  it { should respond_to :creator }
  it { should respond_to :updated_by }
  it { should respond_to :updater }

  describe '#current_user' do
    subject{ Mongoid::Userstamp.current_user }
    context 'when current user is not set' do
      before { User.current = nil }
      it { should be_nil }
    end
    context 'when current user is set' do
      before{ User.current = user_1 }
      it { should eq user_1 }
    end
  end

  context 'when created without a user' do
    before do
      User.current = nil
      subject.save!
    end
    it { subject.created_by.should be_nil }
    it { subject.creator.should be_nil }
    it { subject.updated_by.should be_nil }
    it { subject.updater.should be_nil }
  end

  context 'when creator is manually set' do
    before{ User.current = user_1 }
    context 'set by id' do
      before do
        subject.created_by = user_2._id
        subject.save!
      end
      it 'should not be overridden when saved' do
        subject.created_by.should eq user_2.id
        subject.creator.should eq user_2
        subject.updated_by.should eq user_1.id
        subject.updater.should eq user_1
      end
    end
    context 'set by model' do
      before do
        subject.creator = user_2
        subject.save!
      end
      it 'should not be overridden when saved' do
        subject.created_by.should eq user_2.id
        subject.creator.should eq user_2
        subject.updated_by.should eq user_1.id
        subject.updater.should eq user_1
      end
    end
  end

  context 'when created by a user' do
    before do
      User.current = user_1
      subject.save!
    end

    it { subject.created_by.should == user_1.id }
    it { subject.creator.should == user_1 }
    it { subject.updated_by.should == user_1.id }
    it { subject.updater.should == user_1 }

    context 'when updated by a user' do
      before do
        User.current = user_2
        subject.save!
      end

      it { subject.created_by.should == user_1.id }
      it { subject.creator.should == user_1 }
      it { subject.updated_by.should == user_2.id }
      it { subject.updater.should == user_2 }
    end

    context 'when user has been destroyed' do
      before do
        User.current = user_2
        subject.save!
        user_1.destroy
        user_2.destroy
      end

      it { subject.created_by.should == user_1.id }
      it { subject.creator.should == nil }
      it { subject.updated_by.should == user_2.id }
      it { subject.updater.should == nil }
    end
  end

  describe '#config' do
    before do
      Mongoid::Userstamp.config do |c|
        c.user_reader = :current_user
        c.user_model  = :user

        c.created_column   = :c_by
        c.created_column_opts = {as: :created_by_id}
        c.created_accessor = :created_by

        c.updated_column   = :u_by
        c.updated_column_opts = {as: :updated_by_id}
        c.updated_accessor = :updated_by
      end

      # class definition must come after config
      class Novel
        include Mongoid::Document
        include Mongoid::Userstamp

        field :name
      end
    end
    subject { Novel.new(name: 'Ethyl the Aardvark goes Quantity Surveying') }

    context 'when created by a user' do
      before do
        User.current = user_1
        subject.save!
      end

      it { subject.c_by.should == user_1.id }
      it { subject.created_by_id.should == user_1.id }
      it { subject.created_by.should == user_1 }
      it { subject.u_by.should == user_1.id }
      it { subject.updated_by_id.should == user_1.id }
      it { subject.updated_by.should == user_1 }

      context 'when updated by a user' do
        before do
          User.current = user_2
          subject.save!
        end

        it { subject.c_by.should == user_1.id }
        it { subject.created_by_id.should == user_1.id }
        it { subject.created_by.should == user_1 }
        it { subject.u_by.should == user_2.id }
        it { subject.updated_by_id.should == user_2.id }
        it { subject.updated_by.should == user_2 }
      end
    end
  end

end
