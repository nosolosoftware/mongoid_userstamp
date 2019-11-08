require 'spec_helper'

class HistoryTracker
  include Mongoid::History::Tracker
  include Mongoid::Userstamp
  
  #mongoid_userstamp
end

class NewModel
  include Mongoid::Document
  include Mongoid::History::Trackable
  
  field :name, type: String
  
  track_history on: [:name]
end

describe NewModel, :type => :model do
  let(:user_1) { User.create!(name: 'Charles Dikkens') }
  it "should have updated_by method" do
    @new=NewModel.create(name: "Testing")
    @new.history_tracks.size.should eq 1
    @new.history_tracks.last.updated_by.should eq user_1
  end
end
