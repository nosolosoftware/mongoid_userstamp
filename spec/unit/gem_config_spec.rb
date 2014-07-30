# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Mongoid::Userstamp::GemConfig do

  subject { Mongoid::Userstamp::GemConfig.new }

  describe '#initialize' do

    context 'without block' do
      it { should be_a Mongoid::Userstamp::GemConfig }
      it { subject.created_name.should eq :created_by }
      it { subject.updated_name.should eq :updated_by }
      it { subject.user_reader.should eq :current_user }
    end

    context 'with block' do
      subject do
        Mongoid::Userstamp::GemConfig.new do |u|
          u.created_name  = :c_by
          u.updated_name  = :u_by
          u.user_reader = :foo
        end
      end

      it { should be_a Mongoid::Userstamp::GemConfig }
      it { subject.created_name.should eq :c_by }
      it { subject.updated_name.should eq :u_by }
      it { subject.user_reader.should eq :foo }
    end
  end

  describe 'deprecated methods' do
    subject do
      Mongoid::Userstamp::GemConfig.new do |u|
        u.user_model = :bar
        u.created_column = :bing
        u.updated_column = :baz
      end
    end
    it { ->{ subject }.should_not raise_error }
    it { should be_a Mongoid::Userstamp::GemConfig }
    it { subject.created_name.should eq :bing }
    it { subject.updated_name.should eq :baz }
  end
end
