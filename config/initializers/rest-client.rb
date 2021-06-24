require "rest-client"

RestClient.proxy = ENV["QUOTAGUARDSTATIC_URL"] if ENV["QUOTAGUARDSTATIC_URL"].present?
