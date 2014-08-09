# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Mongoid::Userstamp do

  subject{ Mongoid::Userstamp }

  let(:user_1){ User.create!(name: 'Edmund Wells') }
  let(:user_2){ Admin.create!(name: 'JK Rowling') }

  describe '#config' do

    before { Mongoid::Userstamp.instance_variable_set(:'@config', nil) }

    context 'without block' do
      subject{ Mongoid::Userstamp.config }
      it { should be_a Mongoid::Userstamp::GemConfig }
      it { subject.created_name.should eq :created_by }
      it { subject.updated_name.should eq :updated_by }
      it { subject.user_reader.should eq :current_user }
    end

    context 'with block' do
      subject do
        Mongoid::Userstamp.config do |u|
          u.created_name = :c_by
          u.updated_name = :u_by
          u.user_reader = :foo
        end
      end
      it { should be_a Mongoid::Userstamp::GemConfig }
      it { subject.created_name.should eq :c_by }
      it { subject.updated_name.should eq :u_by }
      it { subject.user_reader.should eq :foo }
    end

    context 'deprecated method' do
      subject{ Mongoid::Userstamp.configure }
      it { should be_a Mongoid::Userstamp::GemConfig }
    end
  end

  describe '#current_user' do
    before do
      Mongoid::Userstamp.set_current_user(user_1)
      Mongoid::Userstamp.set_current_user(user_2)
    end
    context 'when user_class is User' do
      subject{ Mongoid::Userstamp.current_user('User') }
      it{ should eq user_1 }
    end
    context 'when user_class is Admin' do
      subject{ Mongoid::Userstamp.current_user('Admin') }
      it{ should eq user_2 }
    end
    context 'when user_class is other' do
      subject{ Mongoid::Userstamp.current_user('foobar') }
      it{ should be_nil }
    end
    context 'when user_class is not given' do
      subject{ Mongoid::Userstamp.current_user }
      it 'should use the default user_class' do
        should eq user_2
      end
    end
  end

  describe '#model_classes' do
    before { Mongoid::Userstamp.instance_variable_set(:'@model_classes', nil) }
    context 'default value' do
      it { subject.model_classes.should eq [] }
    end
    context 'setting values' do
      before do
        subject.add_model_class 'Book'
        subject.add_model_class 'Post'
      end
      it { subject.model_classes.should eq [Book, Post] }
    end
  end

  describe '#user_classes' do
    before { Mongoid::Userstamp.instance_variable_set(:'@user_classes', nil) }
    context 'default value' do
      it { subject.user_classes.should eq [] }
    end
    context 'setting values' do
      before do
        subject.add_user_class 'Book'
        subject.add_user_class 'Post'
      end
      it { subject.user_classes.should eq [Book, Post] }
    end
  end

  describe '#store' do
    context 'when RequestStore is defined' do
      before do
        stub_const('RequestStore', Object.new)
        RequestStore.stub('store').and_return('foobar')
      end
      it { subject.store.should eq RequestStore.store }
    end
    context 'when RequestStore is not defined' do
      before{ hide_const('RequestStore') }
      it { subject.store.should eq Thread.current }
    end
  end

  describe '#userstamp_key' do
    context 'when model is a Class' do
      subject{ Mongoid::Userstamp.userstamp_key(User) }
      it{ should eq :"mongoid_userstamp/user" }
    end
    context 'when model is a String' do
      subject{ Mongoid::Userstamp.userstamp_key('MyNamespace::User') }
      it{ should eq :"mongoid_userstamp/my_namespace/user" }
    end
  end
end
