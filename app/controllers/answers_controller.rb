class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create, :destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = Answer.new(answer_params.merge({ user: current_user, question: @question }))
    if @answer.save
      redirect_to question_path(@question)
    else
      flash[:error] = "Some errors occured"
      render :new
    end
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    if @answer.user_id == current_user.id
      if @answer.destroy
        flash[:success] = 'Answer succefully deleted'
      end
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
