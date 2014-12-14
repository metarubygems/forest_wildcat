module V1
  class DiffsController < ApplicationController
    def show
      diff = DiffGenerator.new(diff_params)
      fail DiffGenerator::InvalidParameters unless diff.valid?
      render plain: diff.generate
    end

    private

    def diff_params
      params.permit(:from, :to, :format)
    end
  end
end
