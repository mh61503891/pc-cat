module App
  module Tag

    def tag(name, attrs = {}, contents = nil)
      open_tag(name, attrs) + contents.to_s + close_tag(name)
    end
  
    def open_tag(name, attrs = {})
      "<#{name} #{map_attrs_to_html_attrs(attrs)}>"
    end
  
    def close_tag(name)
      "</#{name}>"
    end
  
    def map_attrs_to_html_attrs(attrs)
      code = ''
      attrs.each do |name, value|
        code += %[#{name}='#{value}']
      end
      code
    end

  end
end

module App
  module TwitterCard

    include Tag

    def twitter_card_tag(params)
      return '' if params.blank?
      tags = []
      params.each do |name, value|
        tags << tag('meta', {
          name: "twitter:#{name}",
          content: value
        })
      end
      return tags.compact.join($/)
    end

  end
end

module App
  module OGP

    include Tag
  
    def ogp_tag(params)
      return '' if params.blank?
      tags = []
      params.each do |name, value|
        tags << tag('meta', {
          property: "og:#{name}",
          content: value
        })
      end
      tags.compact.join($/)
    end

  end
end

module App
  module Video

    def video_base_url
      'https://object-storage.tyo1.conoha.io/v1/nc_9dbd179936404f7482bfccf5368fddb7/pc-cat/'
    end

    def video_poster_url_for(content)
      URI.join(video_base_url, "#{content[:category_key]}/#{content[:key]}.png").to_s
    end

    def video_src_url_for(content)
      URI.join(video_base_url, "#{content[:category_key]}/#{content[:key]}.mp4").to_s
    end

  end
end

module App
  module GitHub

    def github_base_url
      'https://github.com/mh61503891/pc-cat/blob/development/content/tracks/'
    end

    def link_to_edit_on_github(content)
      URI.join(github_base_url, "#{content[:category_key]}/#{content[:key]}.srt").to_s
    end

  end
end

use_helper App::TwitterCard
use_helper App::OGP
use_helper App::Video
use_helper App::GitHub
use_helper Nanoc::Helpers::LinkTo
use_helper Nanoc::Helpers::Rendering
