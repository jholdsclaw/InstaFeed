class HashtagSearcherJob < ActiveJob::Base
  queue_as :default

  def perform(hashtag)
=begin
    # check for older photos - check against max_tag_id
    # check for newer photos - check against min_tag_id
    
    max_tag_id = response.pagination.next_max_tag_id
    until max_tag_id.to_s.empty? do
      response = Instagram.tag_recent_media(@tags[0].name, :max_tag_id => max_tag_id)
      max_tag_id = response.pagination.next_max_tag_id
      @media.concat(response)
    end
=end
  end
end
