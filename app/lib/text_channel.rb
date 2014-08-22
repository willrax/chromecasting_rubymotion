class TextChannel < GCKCastChannel
  def didRecieveMessage(message)
    puts "Message recieved: #{message}"
  end
end
