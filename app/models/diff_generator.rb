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
  class RubygemsNotFound < StandardError; end

  def from_gem_file
    "#{from}.gem"
  end

  def to_gem_file
    "#{to}.gem"
  end

  def from_gem_file_path
    Pathname.new(Rails.application.secrets.data_rubygems_dir)
    .join('gems', from_gem_file)
  end

  def to_gem_file_path
    Pathname.new(Rails.application.secrets.data_rubygems_dir)
    .join('gems', to_gem_file)
  end

  def generate
    fail RubygemsNotFound unless from_gem_file_path.file?
    fail RubygemsNotFound unless to_gem_file_path.file?
  end
end
