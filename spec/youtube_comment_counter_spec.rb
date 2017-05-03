require 'youtube_comment_counter'

describe YouTubeCommentCounter do

  let(:video_id) { "video id" }
  let(:search_term) { "search term" }

  let(:query) {{
      part: 'snippet,replies',
      key: ENV['YOUTUBE_API_KEY'],
      maxResults: 100,
      videoId: video_id,
      searchTerms: search_term
  }}
  let(:page) {{
    "pageInfo" => {
      "totalResults" => 10
    }
  }}

  before do
    allow(HTTParty).to receive(:get).and_return page
  end

  it 'queries to YouTube api with the correct data' do
    expect(HTTParty).to receive(:get).with("https://www.googleapis.com/youtube/v3/commentThreads", { query: query })
    described_class.call(video_id, search_term)
  end

  it 'returns the correct number of comments' do
    expect(described_class.call(video_id, search_term)).to eq 10
  end
end
