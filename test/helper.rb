require 'rubygems'
require "minitest/autorun"
require 'mocha/setup'
require 'time'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'arsi'