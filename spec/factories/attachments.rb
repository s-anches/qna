FactoryGirl.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'Gemfile')) }
  end

end
