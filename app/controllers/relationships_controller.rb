class RelationshipsController < ApplicationController
  before_filter :require_user
  def index
    @relationships = current_user.following_relationships
  end

  def create
    Relationship.create(user_id: current_user.id, leader_id: params[:leader_id]) if (relationship_does_not_exist && not_self_relationship)
    redirect_to people_path
  end

  def destroy
    current_user.relationships.find(params[:id]).destroy
    redirect_to people_path
  end

  private

  def relationship_does_not_exist
    Relationship.where(user_id: current_user.id, leader_id: params[:leader_id]).blank?
  end

  def not_self_relationship
    current_user.id != params[:leader_id].to_i
  end
end