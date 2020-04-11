require 'rails_helper'

RSpec.describe Review, type: :model do
  it 'has a valid factory' do
    expect(build(:review)).to be_valid
  end

  describe "title validation" do
    context "without title" do
      it 'is invalid' do
        expect(build(:review, title: "")).not_to be_valid
      end
    end

    context "with 30 Japanese characters title" do
      it 'is valid' do
        valid_title = "あ" * 30
        expect(build(:review, title: valid_title)).to be_valid
      end
    end

    context "with more than 30 Japanese characters title" do
      it 'is invalid' do
        invalid_title = "あ" * 31
        expect(build(:review, title: invalid_title)).not_to be_valid
      end
    end
  end

  describe "content validation" do
    context "without content" do
      it 'is invalid' do
        expect(build(:review, content: "")).not_to be_valid
      end
    end
  end

  describe "cleanliness validation" do
    context "without cleanliness review" do
      it 'is invalid' do
        expect(build(:review, cleanliness: nil)).not_to be_valid
      end
    end
  end

  describe "service validation" do
    context "without service review" do
      it 'is invalid' do
        expect(build(:review, service: nil)).not_to be_valid
      end
    end
  end

  describe "customer validation" do
    context "without customer review" do
      it 'is invalid' do
        expect(build(:review, customer: nil)).not_to be_valid
      end
    end
  end
end
