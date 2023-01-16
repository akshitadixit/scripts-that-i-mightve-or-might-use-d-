require './job'
require 'redis'

=begin
        Task: pull jobs from queue and execute
        Task: Allow more than one jobs to run at a time
        Task: Implement a concurrency limit
        Task: Retry if job fails, implement retry limits
=end

# implement error-handling

class Server
  def initialize
    @queue = Redis.new(host: "localhost", port: 6379, db: 15)
    @concurrency_limit = 3
    @concurrency = 0
    puts "Server initialized\n"
  end

  def queue_length
    @queue.keys('*').length
  end

  def concurrency
    @concurrency
  end

  def concurrency_limit
    @concurrency_limit
  end

  def quit?
    begin
      # See if a 'q' has been typed yet
      while c = STDIN.read_nonblock(1)
        return true if c == 'q'
      end
      # No 'Q' found
      false
    rescue IO::WaitReadable, IO::EAGAINWaitReadable
      IO.select([STDIN])
      retry
    end
  end

  def pull_from_q
    job_s = @queue.blpop('queue1')
    if job_s.length
      @concurrency += 1
      # deserialize
      job = Job.new("")
      job.from_s(job_s)
      t = Thread.new do
        job.run
        @concurrency -= 1
      end
    end
  end

  def finalize
    puts "\nServer closed"
  end
end

puts "Hit ^C to stop the server"
consumer = Server.new
prev_n = -1
begin
  loop do
    n = consumer.queue_length
    if n!=prev_n
      puts "#{n} jobs in queue"
      prev_n = n
    end

    if n == 0
      # if there is nothing on the queue yet, sleep
      sleep 3
    else
      if consumer.concurrency<consumer.concurrency_limit
        consumer.pull_from_q
      end
    end

  end

rescue Interrupt => e
  puts "\b\b.....#{consumer.queue_length} remaining jobs in queue"

end

consumer.finalize
