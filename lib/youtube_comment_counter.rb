require 'httparty'
require 'dotenv'
Dotenv.load

module YouTubeCommentCounter
  class << self

    def call(video_id, search_term)
      query = query({videoId: video_id, searchTerms: search_term})
      page = page(query)
      total_comment_count(page, query)
    end

    private

    def total_comment_count(page, query)
      if page["nextPageToken"]
        next_page_query = query.merge({ pageToken: page["nextPageToken"]})
        next_page = page(next_page_query)
        page_comment_count(page) + total_comment_count(next_page, next_page_query)
      else
        page_comment_count(page)
      end
    end

    def page_comment_count(page)
      page["pageInfo"]["totalResults"]
    end

    def query(options = {})
      {
        part: 'snippet,replies',
        key: ENV['YOUTUBE_API_KEY'],
        maxResults: 100, #This is the max number of comment threads YouTube allows you to pull at one time. If a video has more than that, they will be split into multiple pages.
      }.merge(options)
    end

    def page(query)
      HTTParty.get("https://www.googleapis.com/youtube/v3/commentThreads", {query: query})
    end
  end
end
