require 'tmpdir'
require 'open3'
require 'fileutils'
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
  class GeneratingError < StandardError; end
  class InvalidParameters < StandardError; end

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
    fail RubygemsNotFound if !from_gem_file_path.file? || !to_gem_file_path.file?

    Dir.mktmpdir { |dir|
      from_dir, _ = FileUtils.mkdir_p(File.join(dir, from))
      to_dir, _ = FileUtils.mkdir_p(File.join(dir, to))

      _, e, s = Open3.capture3("tar -O -xf - data.tar.gz| tar -xzf - -C #{from_dir}",
                               stdin_data: from_gem_file_path.binread,
                               binmode: true)
      unless s.success?
        Rails.logger.error e
        fail GeneratingError
      end
      _, e, s = Open3.capture3("tar -O -xf - data.tar.gz| tar -xzf - -C #{to_dir}",
                               stdin_data: to_gem_file_path.binread,
                               binmode: true)
      unless s.success?
        Rails.logger.error e
        fail GeneratingError
      end

      diff_command = []
      diff_command << 'diff'
      if format
        diff_command << "-#{format}"
      else
        diff_command << '-u'
      end
      diff_command << '-r'
      diff_command << from_dir
      diff_command << to_dir

      o, e, s = Open3.capture3(*diff_command)
      # diff's exit status; 0: no diff, 1: diff exist, 2: error
      if s.exitstatus == 2
        Rails.logger.error e
        fail GeneratingError
      end
      return o
    }
  end
end
