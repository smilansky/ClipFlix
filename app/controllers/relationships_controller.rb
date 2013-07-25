class RelationshipsController < ApplicationController

def index
  @leaders = current_user.leaders
end

end