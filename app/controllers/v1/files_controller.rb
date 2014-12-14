module V1
  class FilesController < ApplicationController
    def show
      file = FileExtractor.new(file_params)
      fail FileExtractor::InvalidParameters unless file.valid?
      render plain: file.extract
    end

    private

    def file_params
      params.permit(:name, :version, :platform, :filename)
    end
  end
end
