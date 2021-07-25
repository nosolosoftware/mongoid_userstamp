# frozen_string_literal: true

require 'spec_helper'

describe Mongoid::Userstamp::GlobalConfig do
  subject { Mongoid::Userstamp::GlobalConfig.new }

  describe '#initialize' do
    context 'without block' do
      it { is_expected.to be_a Mongoid::Userstamp::GlobalConfig }
      it { expect(subject.created_by_field).to eq :created_by }
      it { expect(subject.updated_by_field).to eq :updated_by }
      it { expect(subject.controller_current_user).to eq :current_user }
    end

    context 'with block' do
      subject do
        Mongoid::Userstamp::GlobalConfig.new do |u|
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
  end
end
