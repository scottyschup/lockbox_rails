# Okay, this class gets invoked for errors, by name,
# if the request is not local (config.consider_all_requests_local).
# This is because we configure `config.exceptions_app = routes`
# in config/application.rb
# For local requests (eg test and dev) it will instead go to some
# fancy error renderer.
class ErrorsController < ApplicationController
  implemented_codes = [404, 500]

  Rack::Utils::HTTP_STATUS_CODES.each do |code, desc|
    next unless implemented_codes.include? code
    define_method desc.downcase.tr(" ", "_") do
      respond_to do |format|
        format.html { render status: code }
        format.json do
          render status: code, json: { data: [desc] }
        end
      end
    end
  end
end
