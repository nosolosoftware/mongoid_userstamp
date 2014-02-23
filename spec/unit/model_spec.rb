# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Mongoid::Userstamp::Model do

  subject(:book) { Book.new(name: 'Crafting Rails Applications') }
  subject(:post) { Post.new(title: 'Understanding Rails') }

  let(:user_1) { User.create!(name: 'Charles Dikkens') }
  let(:user_2) { User.create!(name: 'Edmund Wells') }
  let(:admin_1) { Admin.create!(name: 'JK Rowling') }
  let(:admin_2) { Admin.create!(name: 'Stephan Norway') }

  #describe '::mongoid_userstamp' do
  #end

  #describe '::mongoid_userstamp_config' do
  #end

  describe '::current_user' do

    before { Admin.current = nil; User.current = nil }

    context 'when current book user is not set' do
      it { Book.current_user.should be_nil }
      it { Post.current_user.should be_nil }
    end

    context 'when current book user is set' do
      before{ User.current = user_1 }
      it { Book.current_user.should eq user_1 }
      it { Post.current_user.should be_nil }
    end

    context 'when current post user is set' do
      before{ Admin.current = admin_1 }
      it { Book.current_user.should be_nil }
      it { Post.current_user.should eq admin_1 }
    end
  end

  describe 'relations and callbacks' do

    context 'when created without a user' do
      before do
        User.current = nil
        Admin.current = nil
        book.save!
        post.save!
      end

      it { book.created_by.should be_nil }
      it { book.updated_by.should be_nil }
      it { post.writer.should be_nil }
      it { post.editor.should be_nil }
    end

    context 'when created with a user' do
      before do
        User.current = user_1
        Admin.current = admin_1
        book.save!
        post.save!
      end

      it { book.created_by.should eq user_1 }
      it { book.updated_by.should eq user_1 }
      it { post.writer.should eq admin_1 }
      it { post.editor.should eq admin_1 }
    end

    context 'when creator is manually set' do
      before do
        User.current = user_1
        Admin.current = admin_1
        book.created_by = user_2
        book.save!
        post.writer = admin_2
        post.save!
      end

      it { book.created_by.should eq user_2 }
      it { book.updated_by.should eq user_1 }
      it { post.writer.should eq admin_2 }
      it { post.editor.should eq admin_1 }
    end

    context 'when updater is manually set' do
      before do
        User.current = user_1
        Admin.current = admin_1
        book.updated_by = user_2
        book.save!
        post.editor = admin_2
        post.save!
      end

      it { book.created_by.should eq user_1 }
      it { book.updated_by.should eq user_1 }
      it { post.writer.should eq admin_1 }
      it { post.editor.should eq admin_1 }
    end

    context 'when user has been destroyed' do
      before do
        User.current = user_1
        Admin.current = admin_1
        book.save!
        post.save!
        user_1.destroy
        admin_1.destroy
      end

      it { Book.first.created_by.should be_nil }
      it { Book.first.updated_by.should be_nil }
      it { Post.first.writer.should be_nil }
      it { Post.first.editor.should be_nil }
    end
  end
end