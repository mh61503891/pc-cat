module VideoTag

  BASE_URL = 'https://object-storage.tyo1.conoha.io/v1/nc_9dbd179936404f7482bfccf5368fddb7/pc-cat/'

  def video_poster_url_for(content)
    URI.join(BASE_URL, "#{content[:category_key]}/#{content[:key]}.png").to_s
  end

  def video_src_url_for(content)
    URI.join(BASE_URL, "#{content[:category_key]}/#{content[:key]}.mp4").to_s
  end

end

module GitHub

  BASE_URL = 'https://github.com/mh61503891/pc-cat/blob/development/content/tracks/'

  def link_to_edit_on_github(content)
    URI.join(BASE_URL, "#{content[:category_key]}/#{content[:key]}.srt").to_s
  end

end

use_helper VideoTag
use_helper Nanoc::Helpers::LinkTo
use_helper Nanoc::Helpers::Rendering
