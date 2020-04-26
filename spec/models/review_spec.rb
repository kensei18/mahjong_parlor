require 'rails_helper'

RSpec.describe Review, type: :model do
  it 'has a valid factory' do
    expect(build(:review)).to be_valid
  end

  describe "images" do
    context "when attaching images" do
      it "is valid" do
        expect(build(:review, :images_attached)).to be_valid
      end
    end
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

  describe "overall validation" do
    context "without overall review" do
      it 'is invalid' do
        expect(build(:review, overall: nil)).not_to be_valid
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

  describe "#blank_stars" do
    let(:review) do
      create(:review,
             overall: 4,
             cleanliness: 5,
             service: 2,
             customer: 1)
    end

    it "returns correct blank stars count" do
      expect(review.blank_stars(:overall)).to eq 1
      expect(review.blank_stars(:cleanliness)).to eq 0
      expect(review.blank_stars(:service)).to eq 3
      expect(review.blank_stars(:customer)).to eq 4
    end
  end

  describe "#shorten_content" do
    let(:review) { create(:review, content: content) }

    context "with 40 or less characters content" do
      let(:content) { "あ" * 40 }

      it "returns a row content" do
        expect(review.shorten_content).to eq review.content
      end
    end

    context "with content over 40 characters" do
      let(:content) { "あ" * 41 }

      it "returns a shortened content" do
        expect(review.shorten_content).to eq "あ" * 40 + "..."
      end
    end
  end
end
