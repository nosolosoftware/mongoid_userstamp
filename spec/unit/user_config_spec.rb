# frozen_string_literal: true

require 'spec_helper'

describe Mongoid::Userstamp::UserConfig do
  subject { Mongoid::Userstamp::UserConfig.new }
  before { Mongoid::Userstamp.stub('config').and_return(OpenStruct.new(controller_current_user: :foo)) }

  describe '#initialize' do
    context 'with opts hash' do
      subject { Mongoid::Userstamp::UserConfig.new(controller_current_user: :bar) }

      it { is_expected.to be_a Mongoid::Userstamp::UserConfig }
      it { expect(subject.controller_current_user).to eq :bar }
    end

    context 'without opts hash' do
      it { is_expected.to be_a Mongoid::Userstamp::UserConfig }
      it { expect(subject.controller_current_user).to eq :foo }
    end
  end
end
