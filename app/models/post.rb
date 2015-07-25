# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  url        :string
#  content    :text
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ActiveRecord::Base
  validates :title, :post_subs, :author, presence: true
  validates_format_of :url, with: URI.regexp(%w(http https)), allow_nil: true

  belongs_to :author, class_name: 'User'
  has_many :post_subs
  has_many :comments
  has_many :subs, through: :post_subs, source: :sub

  def comments_by_parent_id
    comments_hash = Hash.new { |h, k| h[k] = [] }

    self.comments.includes(:author).each do |comment|
      comments_hash[comment.parent_comment_id] << comment
    end

    comments_hash
  end
end
