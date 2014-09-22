$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'models'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'active_record'
require 'active_support/test_case'

require 'mocha/setup'
require "minitest/autorun"

require 'arsi'
require 'user'

require 'database_helper'
