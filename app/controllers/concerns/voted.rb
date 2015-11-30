module Voted
  extend ActiveSupport::Concern
  included do
    before_action :find_vote, only: [:like, :dislike]
  end

  def like
    vote(1)
  end

  def dislike
    vote(-1)
  end

  private
    def find_vote
      @vote_object = controller_name.classify.constantize.find(params[:id])
    end

    def vote(value)
      @vote_object.vote(current_user, value)
      render json: @vote_object.votes.count
    end
end
