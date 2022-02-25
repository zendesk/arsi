require 'bundler/setup'
require 'single_cov'
SingleCov.setup :minitest
require 'arsi'

require 'minitest/autorun'
require 'minitest/rg'
require 'mocha/minitest'

require_relative 'database'
