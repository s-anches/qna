require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:questions) { create_list(:question, 2) }

  describe "GET #index" do
    before { get :index }

    it "show all questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "render index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before { get :show, id: question }

    it "show question" do
      expect(assigns(:question)).to eq question
    end

    it "render show view" do
      expect(response).to render_template :show
    end
  end
  
  describe "GET #new" do
    before { get :new }

    it "assigns a new Question to Question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "save the new question" do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it "redirect to show this question" do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context "with invalid attributes" do
      it "don't save the new question" do
        expect { post :create, question: attributes_for(:wrong_question) }.to_not change(Question, :count)
      end

      it "redirect to create" do
        post :create, question: attributes_for(:wrong_question)
        expect(response).to render_template :new
      end
    end
  end
  
end
