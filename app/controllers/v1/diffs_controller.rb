module V1
  class DiffsController < ApplicationController
    def show
      diff = DiffGenerator.new(diff_params)
      diff.generate
    end

    private

    def diff_params
      params.permit(:from, :to, :format)
    end
  end
end
