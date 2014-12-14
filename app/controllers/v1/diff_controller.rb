module V1
  class DiffController < ApplicationController
    def show
      diff = DiffGenerator.new(diff_params)
    end

    private

    def diff_params
      params.permit(:from, :to, :format)
    end
  end
end
