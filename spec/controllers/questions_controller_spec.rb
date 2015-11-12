require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:questions) { create_list(:question, 2) }
  let(:question_with_answers) { create(:question_with_answers) }

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

    it "show all answers" do
      get :show, id: question_with_answers.id
      expect(assigns(:answers)).to eq question_with_answers.answers
    end
  end
  
  describe "GET #new" do
    sign_in_user
    before { get :new }

    it "assigns a new Question to Question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    sign_in_user
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

  describe "DELETE #destroy" do
    let(:user) { create(:user_with_question) }
    let(:user2) { create(:user_with_question) }

    context 'Authenticated user' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in user
        user2
      end

      it 'delete his question' do
        user.questions.each do |question|
          expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
        end
      end

      it 'do not delete not his question' do
        user2.questions.each do |question|
          expect { delete :destroy, id: question }.to_not change(Question, :count)
        end
      end

      it 'redirect to root view' do
        user.questions.each do |question|
          delete :destroy, id: question
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'Non-authenticated user' do
      it 'do not delete question' do
        question
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it 'redirect to auth page' do
        delete :destroy, id: question
        expect(response).to redirect_to new_user_session_path
      end
    end

  end
end
