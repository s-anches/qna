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
      if current_user.id != @vote_object.user_id && !@vote_object.voted?(current_user.id)
          @vote_object.vote(current_user, value)
          render json: @vote_object.votes.count
      else
        render json: {errors: 'Access forbidden or you already voted'}, status: :forbidden
      end
    end
end
