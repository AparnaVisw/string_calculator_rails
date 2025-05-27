module Api
    module V1
      class CalculationsController < ApplicationController
        def create
            numbers = params[:numbers]
            result = StringCalculator.add(numbers)
            render json: { result: result }
          rescue ArgumentError => e
            render json: { error: e.message }, status: :unprocessable_entity
          end
      end
    end
  end
  