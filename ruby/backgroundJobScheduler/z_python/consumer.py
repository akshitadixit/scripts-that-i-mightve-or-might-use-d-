# consumer.py that takes jobs from queue and executes them

import threading
import redis
import json
import time
from job import Job
from threading import Thread

class Consumer:
    def __init__(self, host='localhost', port=6379, db=0):
        self.__db = redis.Redis(host=host, port=port, db=db)
        self.name = 'queue'
        self.concurrency_limit = 3

    def pop(self):
        if threading.active_count() < self.concurrency_limit:
            job = self.__db.blpop(self.name)
            if job:
                job = json.loads(job[1])
                job = Job(**job)
                print(f"Job popped: {job.name}")
                # run job in new thread
                try:
                    thread = Thread(target=job.run)
                    thread.start()
                except Exception as e:
                    print(f"Job {job.name} failed with error {e}")
        else:
            print(f"Concurrency limit reached")



    def start(self):
        while True:
            # set concurrency as number of threads running
            self.pop()
            time.sleep(1)

if __name__ == '__main__':
    consumer = Consumer()
    try:
        consumer.start()
    except KeyboardInterrupt:
        print("\b\bExiting")
