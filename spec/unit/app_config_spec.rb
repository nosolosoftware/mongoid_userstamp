# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Mongoid::Userstamp::Config::AppConfig do

  subject { Mongoid::Userstamp::Config::AppConfig.new }

  describe '#initialize' do

    context 'without block' do
      its(:model) { should eq :user }
      its(:reader){ should eq :current_user }
    end

    context 'with block' do

      subject do
        Mongoid::Userstamp::Config::UserConfig.new do |u|
          u.model  = :custom_user
          u.reader = :custom_current_user
        end
      end

      its(:model) { should eq :custom_user }
      its(:reader){ should eq :custom_current_user }
    end
  end
end
