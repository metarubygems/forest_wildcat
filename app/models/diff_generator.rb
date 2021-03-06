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
              in: %w(-u --normal -c -e -n -y),
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

    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        from_dir, _ = FileUtils.mkdir_p(from)
        to_dir, _ = FileUtils.mkdir_p(to)
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

        o, e, s = Open3.capture3(*diff_command(from_dir, to_dir, format))
        # diff's exit status; 0: no diff, 1: diff exist, 2: error
        if s.exitstatus == 2
          Rails.logger.error e
          fail GeneratingError
        end
        return o
      end
    end
  end

  def diff_command(from_dir, to_dir, option)
    command = []
    command << 'diff'
    if option
      command << option
    else
      command << '-u'
    end
    command << '-r'
    command << from_dir
    command << to_dir
    command
  end
end
