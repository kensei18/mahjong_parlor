require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#full_title" do
    context "with some page_title" do
      it "returns the page title and base title" do
        expect(full_title('User page')).to eq "User page | Mahjong Parlor"
      end
    end

    context "without page_title" do
      it "returns only the base title" do
        expect(full_title('')).to eq "Mahjong Parlor"
      end
    end

    context "when page_title is nil" do
      it "returns only the base title" do
        expect(full_title(nil)).to eq "Mahjong Parlor"
      end
    end
  end

  describe "#bootstrap_class_for" do
    context "with 'success'" do
      it "returns 'success'" do
        expect(bootstrap_class_for('success')).to eq 'success'
      end
    end

    context "with 'error'" do
      it "returns 'danger'" do
        expect(bootstrap_class_for('error')).to eq 'danger'
      end
    end

    context "with 'alert'" do
      it "returns 'warning'" do
        expect(bootstrap_class_for('alert')).to eq 'warning'
      end
    end

    context "with 'notice'" do
      it "returns 'info'" do
        expect(bootstrap_class_for('notice')).to eq 'info'
      end
    end

    context "with 'info'" do
      it "returns 'info'" do
        expect(bootstrap_class_for('info')).to eq 'info'
      end
    end
  end
end
