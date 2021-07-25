# frozen_string_literal: true

require 'spec_helper'

describe Mongoid::Userstamp do
  subject { Mongoid::Userstamp }

  let(:user1) { User.create!(name: 'Edmund Wells') }
  let(:user2) { User.create!(name: 'Charles Dikkens') }
  let(:admin1) { Admin.create!(name: 'JK Rowling') }

  describe '#config' do
    before { Mongoid::Userstamp.instance_variable_set(:@config, nil) }

    context 'without block' do
      subject { Mongoid::Userstamp.config }
      it { is_expected.to be_a Mongoid::Userstamp::GlobalConfig }
      it { expect(subject.created_by_field).to eq :created_by }
      it { expect(subject.updated_by_field).to eq :updated_by }
      it { expect(subject.controller_current_user).to eq :current_user }
    end

    context 'with block' do
      subject do
        Mongoid::Userstamp.config do |u|
          u.created_by_field = :c_by
          u.updated_by_field = :u_by
          u.controller_current_user = :foo
        end
      end
      it { is_expected.to be_a Mongoid::Userstamp::GlobalConfig }
      it { expect(subject.created_by_field).to eq :c_by }
      it { expect(subject.updated_by_field).to eq :u_by }
      it { expect(subject.controller_current_user).to eq :foo }
    end

    context 'deprecated method' do
      subject { Mongoid::Userstamp.configure }
      it { is_expected.to be_a Mongoid::Userstamp::GlobalConfig }
    end
  end

  describe '#current_user' do
    before do
      Mongoid::Userstamp.set_current_user(user1)
      Mongoid::Userstamp.set_current_user(admin1)
    end
    context 'when user_class is User' do
      subject { Mongoid::Userstamp.current_user('User') }
      it { is_expected.to eq user1 }
    end
    context 'when user_class is Admin' do
      subject { Mongoid::Userstamp.current_user('Admin') }
      it { is_expected.to eq admin1 }
    end
    context 'when user_class is other' do
      subject { Mongoid::Userstamp.current_user('foobar') }
      it { is_expected.to be_nil }
    end
    context 'when user_class is not given' do
      subject { Mongoid::Userstamp.current_user }
      it 'should use the default user_class' do
        should eq admin1
      end
    end
  end

  describe '#model_classes' do
    before { Mongoid::Userstamp.instance_variable_set(:@model_classes, nil) }
    context 'default value' do
      it { expect(subject.model_classes).to eq [] }
    end
    context 'setting values' do
      before do
        subject.add_model_class 'Book'
        subject.add_model_class 'Post'
      end
      it { expect(subject.model_classes).to eq [Book, Post] }
    end
  end

  describe '#user_classes' do
    before { Mongoid::Userstamp.instance_variable_set(:@user_classes, nil) }
    context 'default value' do
      it { expect(subject.user_classes).to eq [] }
    end
    context 'setting values' do
      before do
        subject.add_user_class 'Book'
        subject.add_user_class 'Post'
      end
      it { expect(subject.user_classes).to eq [Book, Post] }
    end
  end

  describe '#store' do
    context 'when RequestStore is defined' do
      before do
        stub_const('RequestStore', Object.new)
        RequestStore.stub('store').and_return('foobar')
      end
      it { expect(subject.store).to eq RequestStore.store }
    end
    context 'when RequestStore is not defined' do
      before { hide_const('RequestStore') }
      it { expect(subject.store).to eq Thread.current }
    end
  end

  describe '#userstamp_key' do
    context 'when model is a Class' do
      subject { Mongoid::Userstamp.userstamp_key(User) }
      it { is_expected.to eq :'mongoid_userstamp/user' }
    end
    context 'when model is a String' do
      subject { Mongoid::Userstamp.userstamp_key('MyNamespace::User') }
      it { is_expected.to eq :'mongoid_userstamp/my_namespace/user' }
    end
  end
end
