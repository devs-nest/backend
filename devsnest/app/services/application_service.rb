# frozen_string_literal: true

# base class for all services
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
