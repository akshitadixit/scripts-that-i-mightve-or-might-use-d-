from dataclasses import dataclass
from datetime import datetime
import os
from typing import Optional

@dataclass
class Job:
    _id: str
    name: str
    script: str # bash file path to be run as a job
    completed : bool = False
    retries: int = 0
    retry_limit: int = 3
    time: Optional[datetime] = None # scheduled run

    @property
    def id(self):
        return self._id

    def run(self):
        print(f"Running job {self.name}")
        try:
            # chmod +x script
            os.system(f"chmod +x {self.script}")
            # run bash script in a subprocess
            os.system(self.script)
            self.completed = True
        except Exception as e:
            print(f"Job {self.name} failed with error {e}")
            self.retries += 1
            if self.retries < self.retry_limit:
                self.run()
            else:
                print(f"Job {self.name} failed after {self.retry_limit} retries")

        if self.completed:
            print(f"Job {self.name} completed successfully")

    def __str__(self):
        return f"Job({self._id}, {self.name}, {self.time})"

    def schedule(self):
        print(f"Scheduling job {self.name} to run at {self.time}")
        # insert job into redis queue sorted according to time
        # ...
