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
            }
  validates :filename,
            presence: true,
            format: {
              with: /\A[\w_\-.\/]+\z/,
              message: 'only allows letters'
            }
end
