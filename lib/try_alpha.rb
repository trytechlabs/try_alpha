# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'http'
require 'thor'

require_relative 'try_alpha/version'
require_relative 'try_alpha/exceptions'
require_relative 'try_alpha/banner'
require_relative 'try_alpha/compiler'
require_relative 'try_alpha/a_p_i'
require_relative 'try_alpha/commands'
require_relative 'try_alpha/c_l_i'

module TryAlpha
  class Error < StandardError; end

  def self.api_url
    if ENV['ALPHA_MODE'] == 'development'
      'http://localhost:3000/api'
    else
      'https://alpha.trytechlabs.com/api'
    end
  end
end
