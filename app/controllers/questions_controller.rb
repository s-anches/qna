class QuestionsController < ApplicationController

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @answers = @question.answers.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      flash[:success] = "New question successfully created"
      redirect_to @question
    else
      flash[:error] = "Some errors occured"
      render :new
    end
  end

  private
    def question_params
      params.require(:question).permit(:title, :body)
    end

end
