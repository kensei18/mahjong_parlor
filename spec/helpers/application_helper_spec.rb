require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
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
end
