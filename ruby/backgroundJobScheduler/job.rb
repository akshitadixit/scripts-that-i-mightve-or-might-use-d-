require 'securerandom'

class Job
  def initialize(title)
      @id = SecureRandom.uuid.to_s
      @title = title
      @timestamp = Time.now
      # @script = script # job is to run this script
      @retry_limit = 2
      @retries = 0
      @completed = false
  end

  def id
    @id
  end

  def to_s
    hash = {
      "id"=> @id,
      "title"=> @title,
      "timestamp"=> @timestamp.to_s,
      "completed"=> @completed.to_s
    }
    return hash.to_s
  end


  def from_s(str)
    hash = str.to_a[1]
    puts hash
    @id = hash["id"].to_s
    @title = hash["title"].to_s
    @timestamp = hash["timestamp"].to_s
    @completed = hash["completed"].to_s
  end

  def run
    # fork("ls")
    # Process.spawn : return process_id
    # system("ls") : returns nil/true based on success

    puts "Running #{@id}"
    sleep 7
    @completed = true

    # check if job ended, remove it from concurrency count
    if @completed
      puts "Completed #{@id}"
    elsif @retries < @retry_limit
      @retries += 1
      @run
    else
      puts "Job #{@id} didn't run after #{@retries} retries"
    end
  end

end
