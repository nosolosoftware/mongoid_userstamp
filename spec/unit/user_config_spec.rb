# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Mongoid::Userstamp::UserConfig do

  subject { Mongoid::Userstamp::UserConfig.new }
  before  { Mongoid::Userstamp.stub('config').and_return(OpenStruct.new(user_reader: :foo)) }

  describe '#initialize' do

    context 'with opts hash' do
      subject { Mongoid::Userstamp::UserConfig.new({reader: :bar}) }

      it { should be_a Mongoid::Userstamp::UserConfig }
      it { subject.reader.should eq :bar }
    end

    context 'without opts hash' do
      it { should be_a Mongoid::Userstamp::UserConfig }
      it { subject.reader.should eq :foo }
    end
  end
end
