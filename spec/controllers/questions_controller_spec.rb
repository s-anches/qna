require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user_one) { create(:user) }
  let(:user_two) { create(:user) }
  let(:question) { create(:question, user: user_one) }
  let(:questions) { create_list(:question, 2, user: user_one) }
  let(:answers) { create_list(:answer, 2, question: question, user: user_one) }

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

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

    it "assigns new answer for question" do
      expect(assigns(:answer)).to be_a_new Answer
    end

    it "build new attachment for answer" do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it "render show view" do
      expect(response).to render_template :show
    end

    it "show all answers" do
      expect(assigns(:answers)).to eq answers
    end
  end

  describe "GET #new" do
    before do
      sign_in user_one
      get :new
    end

    it "assigns a new Question to Question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "build new attachment for question" do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    before { sign_in user_one }
    context "with valid attributes" do
      it "save the new question" do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it "redirect to show this question" do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'have right question owner' do
        expect { post :create, question: attributes_for(:question) }.to change(user_one.questions, :count).by(1)
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
    before { question }

    context 'Authenticated user' do

      it 'delete his question' do
        sign_in user_one
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'do not delete not his question' do
        sign_in user_two
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it 'redirect to root view' do
        sign_in user_one
        delete :destroy, id: question
        expect(response).to redirect_to root_path
      end
    end

    context 'Non-authenticated user' do
      it 'do not delete question' do
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it 'redirect to auth page' do
        delete :destroy, id: question
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH #update" do
    context "Authenticated user with valid atributes" do
      before { sign_in user_one }

      it "assigns the requested question to @question" do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it "change question attributes" do
        patch :update, id: question, question: { body: "Edited body" }, format: :js
        question.reload
        expect(question.body).to eq "Edited body"
      end

      it "render update template" do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context "Authenticated user with invalid atributes" do
      it "don't change question attributes" do
        sign_in user_one
        patch :update, id: question, question: attributes_for(:wrong_question), format: :js
        question.reload

        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end
    end

    context "Authenticated user can't edit not his question" do
      it "don't change question attributes" do
        sign_in user_two
        patch :update, id: question, question: { title: "Edited title", body: "Edited body" }, format: :js
        question.reload

        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end
    end

    context "Non-authenticated user can't edit any question" do
      it "don't change question attributes" do
        patch :update, id: question, question: { title: "Edited title", body: "Edited body" }, format: :js
        question.reload

        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end
    end
  end

  describe 'PATCH #like' do
    context 'Authenticated user set like to question' do
      before { sign_in user_one }

      it 'set like flag on question' do
        expect { patch :like, id: question, format: :json }.to change(question.votes, :count).by(1)
      end
    end

    context 'Non-authenticated user' do
      it "don't change best flag on any answer in question" do
        expect { patch :like, id: question, format: :json }.to_not change(Vote, :count)
      end
    end
  end

end
