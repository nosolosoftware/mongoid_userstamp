# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Mongoid::Userstamp do
  subject(:book) { Book.new(name: 'Crafting Rails Applications') }
  subject(:post) { Post.new(title: 'Understanding Rails') }

  let(:user_1) { User.create!(name: 'Charles Dikkens') }
  let(:user_2) { User.create!(name: 'Edmund Wells') }
  let(:admin_1) { Admin.create!(name: 'JK Rowling') }
  let(:admin_2) { Admin.create!(name: 'Stephan Norway') }

  describe 'configuration' do
    it { Mongoid::Userstamp.timestamped_models.should include(Book) }
    it { Mongoid::Userstamp.timestamped_models.should include(Post) }
    
    context 'when :default' do
      it { Book.userstamp_key.should eq :default }
      it { Book.userstamp_config.should eq Mongoid::Userstamp.configs[:default] }

      it { book.should respond_to :created_by }
      it { book.should respond_to :writer }
      it { book.should respond_to :updated_by }
      it { book.should respond_to :editor }
    end
    context 'when :admin' do
      it { Post.userstamp_key.should eq :admin }
      it { Post.userstamp_config.should eq Mongoid::Userstamp.configs[:admin] }

      it { post.should respond_to :c_by }
      it { post.should respond_to :creator }
      it { post.should respond_to :u_by }
      it { post.should respond_to :updater }
    end
  end

  describe '#current_user' do
    before { Admin.current = nil; User.current = nil }
    subject(:book_user){ Book.current_user }
    subject(:post_user){ Post.current_user }

    context 'when current book user is not set' do
      before { User.current = nil }
      it { book_user.should be_nil }
      it { post_user.should be_nil }
    end

    context 'when current book user is set' do
      before{ User.current = user_1 }
      it { book_user.should eq user_1 }
      it { post_user.should be_nil }
    end

    context 'when current post user is not set' do
      before { Admin.current = nil }
      it { book_user.should be_nil }
      it { post_user.should be_nil }
    end

    context 'when current post user is set' do
      before{ Admin.current = admin_1 }
      it { book_user.should be_nil }
      it { post_user.should eq admin_1 }
    end
  end

  context 'when created without a user' do
    before do
      Admin.current = admin_1
      User.current = nil
      book.save!
    end

    it { book.created_by.should be_nil }
    it { book.writer.should be_nil }
    it { book.updated_by.should be_nil }
    it { book.editor.should be_nil }
  end

  context 'when creator is manually set' do
    before do
      User.current = user_1
      Admin.current = admin_1
    end
  
    context 'set by id' do
      before do
        post.c_by = admin_2._id
        post.save!
      end
  
      it 'should not be overridden when saved' do
        post.c_by.should eq admin_2.id
        post.creator.should eq admin_2
        post.u_by.should eq admin_1.id
        post.updater.should eq admin_1
      end
    end
    context 'set by model' do
      before do
        post.creator = admin_2
        post.save!
      end
      
      it 'should not be overridden when saved' do
        post.c_by.should eq admin_2.id
        post.creator.should eq admin_2
        post.u_by.should eq admin_1.id
        post.updater.should eq admin_1
      end
    end
  end
  
  context 'when created by a user' do
    before do
      Admin.current = admin_1
      User.current = user_1
      book.save!
    end

    it { book.created_by.should == user_1.id }
    it { book.writer.should == user_1 }
    it { book.updated_by.should == user_1.id }
    it { book.editor.should == user_1 }

    context 'when updated by a user' do
      before do
        User.current = user_2
        book.save!
      end

      it { book.created_by.should == user_1.id }
      it { book.writer.should == user_1 }
      it { book.updated_by.should == user_2.id }
      it { book.editor.should == user_2 }
    end

    context 'when user has been destroyed' do
      before do
        User.current = user_2
        book.save!
        user_1.destroy
        user_2.destroy
      end

      it { book.created_by.should == user_1.id }
      it { book.writer.should be_nil }
      it { book.updated_by.should == user_2.id }
      it { book.editor.should be_nil }
    end
  end

  describe '#config' do
    before do
      Mongoid::Userstamp.config(:test) do |c|
        c.user_reader = :test_user
        c.user_model  = :user

        c.created_column   = :c_by
        c.created_column_opts = {as: :created_by_id}
        c.created_accessor = :created_by

        c.updated_column   = :u_by
        c.updated_column_opts = {as: :updated_by_id}
        c.updated_accessor = :updated_by
      end
    end

    subject { Mongoid::Userstamp.configs[:test] }

    it { Mongoid::Userstamp.should respond_to :config }
    it { Mongoid::Userstamp.configs.should have_key(:test) }

    it { subject.user_reader.should == :test_user }
    it { subject.user_model.should == User }
    it { subject.created_column.should == :c_by }
    it { subject.created_column_opts.should == {as: :created_by_id} }
    it { subject.created_accessor.should == :created_by }
    it { subject.updated_column.should == :u_by }
    it { subject.updated_column_opts.should == {as: :updated_by_id} }
    it { subject.updated_accessor.should == :updated_by }
  end

  context 'when using an undefined configuration' do
    it { ->{ Book.send(:mongoid_userstamp, :any_config) }.should raise_error(ConfigurationNotFoundError) }
  end
end