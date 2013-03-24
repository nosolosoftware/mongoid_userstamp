# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Mongoid::Userstamp' do
  subject {
    Book.new(
      :name => 'Crafting Rails Applications'
    )
  }

  it { should respond_to :created_by }
  it { should respond_to :creator }
  it { should respond_to :updated_by }
  it { should respond_to :updator }

  context 'when created without a user' do
    before {
      subject.save!
    }

    it { subject.created_by.should be_nil }
    it { subject.creator.should be_nil }
    it { subject.updated_by.should be_nil }
    it { subject.updator.should be_nil }
  end

  context 'when created by a user' do
    let(:user_1) {
      User.create!(:name => 'Charles Dikkens')
    }

    before {
      User.current = user_1
      subject.save
    }

    it { subject.created_by.should == user_1.id }
    it { subject.creator.should == user_1 }
    it { subject.updated_by.should == user_1.id }
    it { subject.updator.should == user_1 }

    context 'when updated by a user' do
      let(:user_2) {
        User.create!(:name => 'Edmund Wells')
      }

      before {
        User.current = user_2
        subject.save!
      }

      it { subject.created_by.should == user_1.id }
      it { subject.creator.should == user_1 }
      it { subject.updated_by.should == user_2.id }
      it { subject.updator.should == user_2 }
    end
  end
end
