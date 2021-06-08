# require 'socket'
# require 'thread'
require 'gserver'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # @soc = UDPSocket.new
  # begin
  #   @soc.bind("localhost", 1234)
  #   Thread.new do
  #     loop {
  #         text, sender = @soc.recvfrom(16)
  #       p text
  #     }
  #   end
  # rescue
  #   p "Only one usage of each socket address (protocol/network address/port) is normally permitted. - bind(2)"
  # end

end
