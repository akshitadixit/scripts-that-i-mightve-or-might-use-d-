require './job'
require 'redis'

=begin
        Task: Push job to queue
=end


# implement error-handling

class Client
  def initialize
    @queue = Redis.new(host: "localhost", port: 6379, db: 15)
    puts "Client initialized"
  end

  def create_job()
    print "Enter Job: "
    Job.new(gets.chomp)
  end

  def push_to_q(job)
    @queue.rpush('queue1', job.to_s)
    puts "Pushed #{job.id}"
  end

  def finalize
    puts "Client closed"
  end
end

producer = Client.new
loop do
  job = producer.create_job
  producer.push_to_q(job)
  print "Exit [y/n]? "
  ch = gets.chomp
  break if ch == "y"
end
producer.finalize
