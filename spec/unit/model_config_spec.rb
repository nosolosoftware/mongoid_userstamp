# frozen_string_literal: true

require 'spec_helper'

describe Mongoid::Userstamp::ModelConfig do
  subject { Mongoid::Userstamp::ModelConfig.new }
  before  do
    Mongoid::Userstamp.stub('config').and_return(OpenStruct.new(created_by_field: :created_by,
                                                                updated_by_field: :updated_by))
  end
  before { Mongoid::Userstamp.stub('user_classes').and_return(['User']) }

  describe '#initialize' do
    context 'with opts hash' do
      subject do
        Mongoid::Userstamp::ModelConfig.new(user_class_name: 'Bar',
                                            created_by_field: :c_by,
                                            updated_by_field: :u_by)
      end

      it { is_expected.to be_a Mongoid::Userstamp::ModelConfig }
      it { expect(subject.user_class_name).to eq 'Bar' }
      it { expect(subject.created_by_field).to eq :c_by }
      it { expect(subject.updated_by_field).to eq :u_by }
    end

    context 'without opts hash' do
      it { is_expected.to be_a Mongoid::Userstamp::ModelConfig }
      it { expect(subject.user_class_name).to eq 'User' }
      it { expect(subject.created_by_field).to eq :created_by }
      it { expect(subject.updated_by_field).to eq :updated_by }
    end
  end
end
