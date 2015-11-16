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

  describe 'DELETE #destroy' do
    before { answer }
    
    context 'Authenticated user' do

      it 'delete his answer' do
        sign_in user_one
        expect { delete :destroy, question_id: question.id, id: answer }.to change(Answer, :count).by(-1)
      end

      it 'do not delete not his answer' do
        sign_in user_two
        expect { delete :destroy, question_id: question.id, id: answer }.to_not change(Answer, :count)
      end

      it 'redirect to question page' do
        sign_in user_one
        delete :destroy, question_id: question.id, id: answer
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Non-authenticated user' do
      it 'do not delete any answer' do
        expect { delete :destroy, question_id: question.id, id: answer }.to_not change(Answer, :count)
      end

    end

  end
end
