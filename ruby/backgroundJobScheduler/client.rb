require './job'
require 'redis'

=begin
        Task: Push job to queue
=end


# implement error-handling

class Client
  def initialize
    @queue = Redis.new(host: "localhost", port: 6379, db: 15)
    puts "Client initialized\n\n"
  end

  def create_job(prompt)
    print "Job Scheduler Client: "
    Job.new(prompt)
  end

  def push_to_q(job)
    @queue.rpush('queue1', job.to_string) #serialized
    puts "Pushed #{job.id}"
  end

  def finalize
    puts "Client closed"
  end
end

producer = Client.new
loop do
  print ">> "
  prompt = gets.chomp
  break if prompt == "exit"
  job = producer.create_job(prompt)

  producer.push_to_q(job)
end
producer.finalize
