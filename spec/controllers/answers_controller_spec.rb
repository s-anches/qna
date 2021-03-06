require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user_one) { create(:user) }
  let(:user_two) { create(:user) }
  let(:question) { create(:question, user: user_one) }
  let(:answer) { create(:answer, question: question, user: user_one) }
  let(:foreign_answer) { create(:answer, question: question) }
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
      before { sign_in user_one }

      it 'can not like his answer' do
        expect { patch :like, id: answer, question_id: question.id, format: :json }.to_not change(answer.votes, :count)
      end

      it 'can like foreign answer' do
        expect { patch :like, id: foreign_answer, question_id: question.id, format: :json }.to change(foreign_answer.votes, :count).by(1)
      end

      it 'can like only once' do
        expect { patch :like, id: foreign_answer, question_id: question.id, format: :json }.to change(foreign_answer.votes, :count).by(1)
        expect { patch :like, id: foreign_answer, question_id: question.id, format: :json }.to_not change(foreign_answer.votes, :count)
      end

      it 'render json' do
        json = %({"rating": 1, "object": #{foreign_answer.id}})
        patch :like, id: foreign_answer, question_id: question.id, format: :json
        expect(response.body).to be_json_eql(json)
      end
    end

    context 'Non-authenticated user' do
      it 'can not like answer' do
        expect { patch :like, id: answer, question_id: question.id, format: :json }.to_not change(Vote, :count)
      end
    end
  end

  describe 'PATCH #dislike' do
    context 'Authenticated user' do
      before { sign_in user_one }

      it 'can not dislike his answer' do
        expect { patch :dislike, id: answer, question_id: question.id, format: :json }.to_not change(answer.votes, :count)
      end

      it 'can dislike foreign answer' do
        expect { patch :dislike, id: foreign_answer, question_id: question.id, format: :json}.to change(foreign_answer.votes, :count).by(1)
      end

      it 'can dislike only once' do
        expect { patch :dislike, id: foreign_answer, question_id: question.id, format: :json}.to change(foreign_answer.votes, :count).by(1)
        expect { patch :dislike, id: foreign_answer, question_id: question.id, format: :json}.to_not change(foreign_answer.votes, :count)
      end

      it 'render json' do
        json = %({"rating": 1, "object": #{foreign_answer.id}})
        patch :like, id: foreign_answer, question_id: question.id, format: :json
        expect(response.body).to be_json_eql(json)
      end
    end

    context 'Non-authenticated user' do
      it 'can not dislike answer' do
        expect { patch :dislike, id: answer, question_id: question.id, format: :json }.to_not change(Vote, :count)
      end
    end
  end

  describe 'DELETE #unvote' do
    context 'Authenticated user' do
      before do
        sign_in user_one
        patch :like, id: foreign_answer, question_id: question.id, format: :json
      end

      it 'Owner can delete his vote' do
        expect { delete :unvote, id: foreign_answer, question_id: question.id, format: :json }.to change(foreign_answer.votes, :count).by(-1)
      end

      it 'render json success' do
        json = %({"rating": 0, "object": #{foreign_answer.id}})
        delete :unvote, id: foreign_answer, question_id: question.id, format: :json
        expect(response.body).to be_json_eql(json)
      end

      it 'render json error' do
        json = %({"errors": "Object not found"})
        delete :unvote, id: foreign_answer, question_id: question.id, format: :json
        delete :unvote, id: foreign_answer, question_id: question.id, format: :json
        expect(response.status).to eq 404
        expect(response.body).to be_json_eql(json)
      end
    end
  end
end
