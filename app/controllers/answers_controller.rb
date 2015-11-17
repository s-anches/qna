class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question

  def create
    @answer = @question.answers.create(answer_params.merge({ user: current_user }))
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    if @answer.user_id == current_user.id
      @answer.destroy
      flash[:success] = 'Answer succefully deleted'
    else
      flash[:error] = "Some errors occured"
    end
    redirect_to question_path(@question)
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end

end
