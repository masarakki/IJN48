#\ -p 2411
$:.unshift File.expand_path('../lib', __FILE__)

require 'naka'
run Naka::Server
