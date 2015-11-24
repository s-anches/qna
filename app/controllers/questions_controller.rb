class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
    @answers = @question.answers.all
  end

  def new
    @user = current_user
    @question = @user.questions.new
    @question.attachments.build
  end

  def create
    @user = current_user
    @question = @user.questions.new(question_params)

    if @question.save
      flash[:success] = "New question successfully created"
      redirect_to @question
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.id == @question.user_id
  end

  def destroy
    if @question.user_id == current_user.id
      @question.destroy
      flash[:success] = "Question succesfully deleted."
      redirect_to root_path
    else
      flash[:error] = "Permission denied."
      redirect_to question_path(@question)
    end
  end

  private
    def load_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy])
    end

end
