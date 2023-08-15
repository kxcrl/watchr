require 'elasticsearch/model'

class Movie < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks unless Rails.env.test?

  has_many :favorites
  has_many :favorited_by, through: :favorites, source: :user

  def as_json(options = {})
    default_options = { only: [:id, :title, :year] }
    super(default_options.merge(options))
  end
end
