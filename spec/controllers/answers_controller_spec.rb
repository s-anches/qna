require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:answer2) { create(:answer) }
  let(:wrong_answer) { create(:wrong_answer) }

  describe "GET #new" do
    sign_in_user
    before { get :new, question_id: question.id }

    it "assigns a new Answer to Answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    sign_in_user
    context "with valid attributes" do
      it "save the new answer to question" do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it "redirect to show this question" do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context "with invalid attributes" do
      it "don't save the new answer" do
        expect { post :create, question_id: question.id, answer: attributes_for(:wrong_answer) }.to_not change(Answer, :count)
      end

      it "redirect to create" do
        post :create, question_id: question.id, answer: attributes_for(:wrong_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'Authenticated user' do
      sign_in_user
      before do
        answer
      end

      it 'delete his answer' do
        expect { delete :destroy, question_id: answer.question_id, id: answer.id }.to change(Answer, :count).by(-1)
      end

      it 'do not delete not his answer' do
        expect { delete :destroy, question_id: answer2.question_id, id: answer2.id }.to_not change(Answer, :count)
      end

      it 'redirect to question page' do
        delete :destroy, question_id: answer.question_id, id: answer.id
        expect(response).to redirect_to question_path(answer.question_id)
      end
    end

  end
end
