require 'youtube_wrapper'

describe YouTubeWrapper do

  let(:video_id) { "rLibXEawkTI" }
  let(:search_term) { "arrival" }

  subject { described_class.new(video_id, search_term) }

  it 'takes a video id and search term'
  it 'returns a count of all comments on that video containing the search term'
end
