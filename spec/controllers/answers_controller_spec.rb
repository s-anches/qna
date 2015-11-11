require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:wrong_answer) { create(:wrong_answer) }

  describe "GET #new" do
    before { get :new, question_id: question.id }

    it "assigns a new Answer to Answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
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
end
