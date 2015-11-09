require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe "GET #index" do
    before do
      get :index
    end

    it "show all questions" do
      @questions = create_list(:question, 2)
      expect(assigns(:questions)).to match_array(@questions)
    end

    it "render index view" do
      expect(response).to render_template :index
    end

  end

  describe "GET #new " do
    
  end

end
