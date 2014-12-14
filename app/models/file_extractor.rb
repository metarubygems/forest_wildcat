require 'open3'
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

  def target_gem_file
    if platform
      "#{name}-#{version}-#{platform}.gem"
    else
      "#{name}-#{version}.gem"
    end
  end

  def target_gem_file_path
    Pathname.new(Rails.application.secrets.data_rubygems_dir)
      .join('gems', target_gem_file)
  end

  def extract
    fail RubygemsNotFound unless target_gem_file_path.file?
    # FIXME: insecure??
    o, e, s = Open3.capture3("tar -O -xf - data.tar.gz| tar -O -xzf - #{filename}",
                             stdin_data: target_gem_file_path.binread,
                             binmode: true)
    unless s.success?
      Rails.logger.error e
      fail FileNotFound
    end

    o
  end
end
