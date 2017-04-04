require 'httparty'
require 'dotenv'
Dotenv.load

class YouTubeWrapper
  include HTTParty
  base_uri 'https://www.googleapis.com'


  def initialize(video_id, search_term)
    @options = { query: {
      part: 'snippet,replies',
      key: ENV['YOUTUBE_API_KEY'],
      maxResults: 100,
      videoId: video_id,
      searchTerms: search_term
    }}
    @comment_count = 0
  end


  def comment_list
    page = comment_page
    next_page_token = page["nextPageToken"]
    next_page = comment_page(next_page_token)
    while next_page_token != next_page["nextPageToken"]
      page = next_page
      next_page_token = page["nextPageToken"]
      next_page = comment_page(next_page_token)
    end
  end

  def comment_page(page_token = nil)
    self.class.get("/youtube/v3/commentThreads", @options.merge(pageToken: page_token))
  end
end

yt = YouTubeWrapper.new("nZYoKHl3Lms", "zodiac")
puts yt.comment_page
