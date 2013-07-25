class RelationshipsController < ApplicationController

def index
  @leaders = current_user.leaders
end

def create
  leader = params[:leader_id]
  Relationship.create(user_id: current_user.id, leader_id: leader.id)
  redirect_to people_path
end

end