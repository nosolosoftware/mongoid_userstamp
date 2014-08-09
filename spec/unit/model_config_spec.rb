# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Mongoid::Userstamp::ModelConfig do

  subject { Mongoid::Userstamp::ModelConfig.new }
  before  { Mongoid::Userstamp.stub('config').and_return(OpenStruct.new(created_name: :created_by,
                                                                        updated_name: :updated_by)) }
  before  { Mongoid::Userstamp.stub('user_classes').and_return(['User']) }

  describe '#initialize' do

    context 'with opts hash' do
      subject { Mongoid::Userstamp::ModelConfig.new(user_model: :bar,
                                                    created_name: :c_by,
                                                    updated_name: :u_by) }

      it { should be_a Mongoid::Userstamp::ModelConfig }
      it { subject.user_model.should eq :bar }
      it { subject.created_name.should eq :c_by }
      it { subject.updated_name.should eq :u_by }
    end

    context 'without opts hash' do
      it { should be_a Mongoid::Userstamp::ModelConfig }
      it { subject.user_model.should eq 'User' }
      it { subject.created_name.should eq :created_by }
      it { subject.updated_name.should eq :updated_by }
    end
  end
end
