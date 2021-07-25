# frozen_string_literal: true

require 'spec_helper'

describe Mongoid::Userstamp::Model do
  subject(:book) { Book.new(name: 'Crafting Rails Applications') }
  subject(:post) { Post.new(title: 'Understanding Rails') }

  let(:user1) { User.create!(name: 'Charles Dikkens') }
  let(:user2) { User.create!(name: 'Edmund Wells') }
  let(:admin1) { Admin.create!(name: 'JK Rowling') }
  let(:admin2) { Admin.create!(name: 'Stephan Norway') }

  describe '::_userstamp_model_config' do
    before do
      @config = Book.instance_variable_get(:@_userstamp_model_config)
      Book.instance_variable_set(:@_userstamp_model_config, nil)
    end

    after do
      Book.instance_variable_set(:@_userstamp_model_config, @config)
    end

    context 'when userstamp has not been set' do
      subject { Book._userstamp_model_config }
      it { should be_a Mongoid::Userstamp::ModelConfig }
      it { expect(subject.user_class_name).to eq 'Admin' }
      it { expect(subject.created_by_field).to eq :created_by }
      it { expect(subject.updated_by_field).to eq :updated_by }
    end

    context 'when set via userstamp method' do
      subject do
        Book.userstamp(user_class_name: 'User', created_by_field: :foo, updated_by_field: :bar)
        Book._userstamp_model_config
      end
      it { is_expected.to be_a Mongoid::Userstamp::ModelConfig }
      it { expect(subject.user_class_name).to eq 'User' }
      it { expect(subject.created_by_field).to eq :foo }
      it { expect(subject.updated_by_field).to eq :bar }
    end
  end

  describe '::current_user' do
    before do
      Admin.current_user = nil
      User.current_user = nil
    end

    context 'when current book user is not set' do
      it { expect(Book.current_user).to be_nil }
      it { expect(Post.current_user).to be_nil }
    end

    context 'when current book user is set' do
      before { User.current_user = user1 }
      it { expect(Book.current_user).to eq user1 }
      it { expect(Post.current_user).to be_nil }
    end

    context 'when current post user is set' do
      before { Admin.current_user = admin1 }
      it { expect(Book.current_user).to be_nil }
      it { expect(Post.current_user).to eq admin1 }
    end
  end

  describe 'relations and callbacks' do
    context 'when created without a user' do
      before do
        User.current_user = nil
        Admin.current_user = nil
        book.save!
        post.save!
      end

      it { expect(book.created_by).to be_nil }
      it { expect(book.updated_by).to be_nil }
      it { expect(post.writer).to be_nil }
      it { expect(post.editor).to be_nil }
    end

    context 'when created with a user' do
      before do
        User.current_user = user1
        Admin.current_user = admin1
        book.save!
        post.save!
      end

      it { expect(book.created_by).to eq user1 }
      it { expect(book.updated_by).to eq user1 }
      it { expect(post.writer).to eq admin1 }
      it { expect(post.editor).to eq admin1 }
    end

    context 'when creator is manually set' do
      before do
        User.current_user = user1
        Admin.current_user = admin1
        book.created_by = user2
        book.save!
        post.writer_id = admin2._id
        post.save!
      end

      it { expect(book.created_by).to eq user2 }
      it { expect(book.updated_by).to eq user1 }
      it { expect(post.writer).to eq admin2 }
      it { expect(post.editor).to eq admin1 }
    end

    context 'when updater is manually set' do
      before do
        User.current_user = user1
        Admin.current_user = admin1
        book.updated_by = user2
        book.save!
        post.editor_id = admin2._id
        post.save!
      end

      it { expect(book.created_by).to eq user1 }
      it { expect(book.updated_by).to eq user2 }
      it { expect(post.writer).to eq admin1 }
      it { expect(post.editor).to eq admin2 }
    end

    context 'when user has been destroyed' do
      before do
        User.current_user = user1
        Admin.current_user = admin1
        book.save!
        post.save!
        user1.destroy
        admin1.destroy
      end

      it { expect(Book.first.created_by).to be_nil }
      it { expect(Book.first.updated_by).to be_nil }
      it { expect(Post.first.writer).to be_nil }
      it { expect(Post.first.editor).to be_nil }
    end
  end
end
