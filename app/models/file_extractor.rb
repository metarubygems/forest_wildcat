class FileExtractor
  include ActiveModel::Model
  attr_accessor :name, :version, :platform, :filename
  validates :name,
            presence: true,
            format: {
              with: /\A[\w_\-.]+\z/,
              message: 'only allows letters'
            }
  validates :version,
            presence: true,
            format: {
              with: /\A[\w_\-.]+\z/,
              message: 'only allows letters'
            }
  validates :platform,
            format: {
              with: /\A[\w_\-.]+\z/,
              message: 'only allows letters'
            },
            if: 'platform.present?'
  validates :filename,
            presence: true,
            format: {
              with: /\A[\w_\-.\/]+\z/,
              message: 'only allows letters'
            }

  class RubygemsNotFound < StandardError; end
  class FileNotFound < StandardError; end
  class InvalidParameters < StandardError; end
end
