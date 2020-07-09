require 'sqlite3'
require 'active_record'
require 'active_model_serializers'
require 'csv'
require 'srt'

ActiveRecord::Base.establish_connection({
  adapter: 'sqlite3',
  database: ':memory:'
})

ActiveRecord::Base.connection.create_table(:categories) do |t|
  t.string :key, null: false
  t.string :title
  t.string :description
end
ActiveRecord::Base.connection.add_index :categories, [:key], unique: true

ActiveRecord::Base.connection.create_table(:contents) do |t|
  t.string :category_key, null: false
  t.string :key, null: false
  t.string :title
  t.string :description
end
ActiveRecord::Base.connection.add_index :contents, [:category_key, :key], unique: true

class Category < ActiveRecord::Base
end

class Content < ActiveRecord::Base

  def category
    Category.find_by(key: category_key)
  end

end

class CategorySerializer < ActiveModel::Serializer

  attributes :key, :title, :description

  def description
    if object.description.blank?
      "このカテゴリでは#{object.title}について解説します。"
    else
      object.description
    end
  end

end

class ContentSerializer < ActiveModel::Serializer

  attributes :category_key, :key, :title, :description, :video_poster_url, :video_src_url

  def description
    if object.description.blank?
      "この動画では#{object.category.title}における#{object.title}について解説します。"
    else
      object.description
    end
  end

  def video_poster_url
    URI.join('https://object-storage.tyo1.conoha.io/v1/nc_9dbd179936404f7482bfccf5368fddb7/pc-cat/', "#{object.category_key}/#{object.key}.png").to_s
  end

  def video_src_url
    URI.join('https://object-storage.tyo1.conoha.io/v1/nc_9dbd179936404f7482bfccf5368fddb7/pc-cat/', "#{object.category_key}/#{object.key}.mp4").to_s
  end

end

class CsvDataSource < ::Nanoc::DataSource

  identifier :contents

  def up
    load_categories
    load_contents
  end

  def load_categories
    CSV.read("content/categories.csv", headers: true).each do |row|
      params = {
        key: row['key'],
        title: row['title'],
        description: row['description'],
      }.compact
      Category.create!(params)
    end
  end

  def load_contents
    CSV.read("content/contents.csv", headers: true).each do |row|
      params = {
        key: row['key'],
        category_key: row['category_key'],
        title: row['title'],
        description: row['description'],
      }.compact
      Content.create!(params)
    end
  end

  def categories
    @categories ||= ActiveModel::Serializer::CollectionSerializer.new(
      Category.all,
      each_serializer: CategorySerializer
    ).map(&:serializable_hash)
  end

  def contents(category_key)
    @contents ||= {}
    @contents[category_key] ||= ActiveModel::Serializer::CollectionSerializer.new(
      Content.where(category_key: category_key),
      each_serializer: ContentSerializer
    ).map(&:serializable_hash)
  end

  def tracks(content)
    return SRT::File.parse(File.new("content/tracks/#{content[:category_key]}/#{content[:key]}.srt")).lines
  rescue
    return []
  end

  def items
    items = []
    items << new_item('', {
      route_key: 'root',
      site_title: '情報リテラシ | コンピュータ演習',
      page_title: 'カテゴリ一覧',
      categories: categories
    }, "/index.html")
    categories.each do |category|
      items << new_item('', {
        route_key: 'category',
        site_title: '情報リテラシ | コンピュータ演習',
        page_title: category[:title],
        category: category,
        contents: contents(category[:key]),
      }, "/#{category[:key]}/index.html")
    end
    categories.each do |category|
      contents(category[:key]).each do |content|
        items << new_item('', {
          route_key: 'content',
          site_title: '情報リテラシ | コンピュータ演習',
          page_title: '',
          category: category,
          content: content,
          tracks: tracks(content),
        }, "/#{category[:key]}/#{content[:key]}.html")
      end
    end
    return items
  end

end
