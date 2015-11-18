class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question

  def create
    @answer = @question.answers.create(answer_params.merge({ user: current_user }))
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params) if current_user.id == @answer.user_id
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    if @answer.user_id == current_user.id
      @answer.destroy
      flash[:success] = "Answer succefully deleted"
    end
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end

end
