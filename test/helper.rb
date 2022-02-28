require 'bundler/setup'
require 'single_cov'
SingleCov.setup :minitest
require 'arsi'

require 'maxitest/autorun'
require 'mocha/minitest'

require_relative 'database'
