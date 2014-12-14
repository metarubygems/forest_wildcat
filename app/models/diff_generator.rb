class DiffGenerator
  include ActiveModel::Model
  attr_accessor :from, :to, :format
  validates :from,
            presence: true,
            format: {
              with: /\A[\w_\-.]+\z/,
              message: 'only allows letters'
            }
  validates :to,
            presence: true,
            format: {
              with: /\A[\w_\-.]+\z/,
              message: 'only allows letters'
            }
  validates :format,
            presence: true,
            inclusion: {
              in: %w(u),
              message: '%{value} is not a valid format'
            },
            if: 'format.present?'
end
