require 'httparty'
require 'dotenv'
Dotenv.load

class YouTubeCommentCounter
  def initialize(video_id, search_term)
    @query = {
      part: 'snippet,replies',
      key: ENV['YOUTUBE_API_KEY'],
      maxResults: 100,
      videoId: video_id,
      searchTerms: search_term
    }
    @comment_count = 0
  end

  def count(page_token = nil)
    page = page(page_token)
    @comment_count += comment_count(page)
    if page["nextPageToken"]
      count(page["nextPageToken"])
    else
      @comment_count
    end
  end

  private
  def page(page_token)
    @query.merge!(pageToken: page_token) if page_token
    HTTParty.get("https://www.googleapis.com/youtube/v3/commentThreads", {query: @query})
  end

  def comment_count(page)
    page["pageInfo"]["totalResults"]
  end
end
