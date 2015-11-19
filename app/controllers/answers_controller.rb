class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, except: [:create]

  def create
    @answer = @question.answers.create(answer_params.merge({ user: current_user }))
  end

  def update
    @answer.update(answer_params) if current_user.id == @answer.user_id
  end

  def destroy
    if @answer.user_id == current_user.id
      @answer.destroy
      @notice = "Answer succefully deleted"
    end
  end

  def set_best
    @answer.set_best if current_user.id == @question.user_id
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = @question.answers.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end

end
