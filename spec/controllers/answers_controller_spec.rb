require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user_one) { create(:user) }
  let(:user_two) { create(:user) }
  let(:question) { create(:question, user: user_one) }
  let(:answer) { create(:answer, question: question, user: user_one) }
  let(:wrong_answer) { create(:wrong_answer, question: question, user: user_one) }

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe "POST #create" do
    before { sign_in user_one }
    context "with valid attributes" do
      it "save the new answer to question" do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it "render create" do
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end

      it "have right answer owner" do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.to change(user_one.answers, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "don't save the new answer" do
        expect { post :create, question_id: question.id, answer: attributes_for(:wrong_answer), format: :js }.to_not change(Answer, :count)
      end

      it "render create" do
        post :create, question_id: question.id, answer: attributes_for(:wrong_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe "PATCH #update" do
    context "Authenticated user with valid attributes" do
      before { sign_in user_one }
      it "assigns the requested answer to @answer" do
        patch :update, id: answer, question_id: question.id, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end
      it "assigns question to @question" do
        patch :update, id: answer, question_id: question.id, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end
      it "change answer attributes" do
        patch :update, id: answer, question_id: question.id, answer: { body: "Edited body" }, format: :js
        answer.reload
        expect(answer.body).to eq "Edited body"
      end
      it "render update template" do
        patch :update, id: answer, question_id: question.id, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context "Authenticated user with invalid attributes" do
      before { sign_in user_one }
      it "don't change answer attributes" do
        patch :update, id: answer, question_id: question.id, answer: attributes_for(:wrong_answer), format: :js
        answer.reload

        expect(answer.body).to eq "This is test answer"
      end
    end

    context "Authenticated user can't edit not his question" do
      before { sign_in user_two }
      it "don't change answer attributes" do
        patch :update, id: answer, question_id: question.id, answer: { body: "Edited body" }, format: :js
        answer.reload

        expect(answer.body).to eq "This is test answer"
      end
    end
    context "Non-authenticated user can't edit any question" do
      it "don't change answer attributes" do
        patch :update, id: answer, question_id: question.id, answer: { body: "Edited body" }, format: :js
        answer.reload

        expect(answer.body).to eq "This is test answer"
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    context 'Authenticated user' do

      it 'delete his answer' do
        sign_in user_one
        expect { delete :destroy, question_id: question.id, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'do not delete not his answer' do
        sign_in user_two
        expect { delete :destroy, question_id: question.id, id: answer, format: :js }.to_not change(Answer, :count)
      end

      it 'render delete template' do
        sign_in user_one
        delete :destroy, question_id: question.id, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Non-authenticated user' do
      it 'do not delete any answer' do
        expect { delete :destroy, question_id: question.id, id: answer, format: :js }.to_not change(Answer, :count)
      end

    end

  end

  describe 'PATCH #set_best' do
    context "Authenticated user edit own question" do
      before { sign_in user_one }

      it 'change best flag on own question' do
        patch :set_best, id: answer, question_id: question.id, format: :js
        answer.reload
        expect(answer.best).to eq true
      end

      it 'render set_best template' do
        patch :set_best, id: answer, question_id: question.id, format: :js
        expect(response).to render_template :set_best
      end
    end

    context "Authenticated user can't edit not his question" do
      before { sign_in user_two }

      it "don't change best flag on foreign question" do
        patch :set_best, id: answer, question_id: question.id, format: :js
        answer.reload
        expect(answer.best).to eq false
      end
    end

    context "Non-authenticated user" do
      it "don't change best flag on any answer in question" do
        patch :set_best, id: answer, question_id: question.id, format: :js
        answer.reload
        expect(answer.best).to eq false
      end
    end
  end

  describe 'PATCH #like' do
    context 'Authenticated user' do
      it 'can not set like on his answer' do
        sign_in user_one
        expect { patch :like, id: answer, question_id: question.id, format: :json }.to_not change(answer.votes, :count)
      end

      it 'can set like on foreign answer' do
        sign_in user_two
        expect { patch :like, id: answer, question_id: question.id, format: :json }.to change(answer.votes, :count).by(1)
      end

      it 'can vote only once' do
        sign_in user_two
        expect { patch :like, id: answer, question_id: question.id, format: :json }.to change(answer.votes, :count).by(1)
        expect { patch :like, id: answer, question_id: question.id, format: :json }.to_not change(answer.votes, :count)
      end
    end

    context 'Non-authenticated user' do
      it "don't change like flag on answer" do
        expect { patch :like, id: answer, question_id: question.id, format: :json }.to_not change(Vote, :count)
      end
    end
  end
end
