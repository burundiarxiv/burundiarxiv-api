require "rails_helper"

RSpec.describe "youtubers/index.html.erb", type: :view do
  let(:youtuber) { create(:youtuber) }

  before do
    assign(:youtubers, [youtuber])
    render
  end

  it "renders a list of youtubers" do
    assert_select "tr>td", text: "1", count: 1
    assert_select "tr>td", text: youtuber.title.to_s, count: 1
    assert_select "tr>td", text: youtuber.view_count.to_s, count: 1
    assert_select "tr>td", text: youtuber.subscriber_count.to_s, count: 1
    assert_select "tr>td", text: youtuber.video_count.to_s, count: 1
  end
end
