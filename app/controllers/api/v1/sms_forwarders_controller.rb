# frozen_string_literal: true

module Api
  module V1
    class SmsForwardersController < ApplicationController
      def create
        puts 'NEW ENTRY'
        puts '-----------------'
        p params
        puts '-----------------'
        puts '-----------------'
      end
    end
  end
end
