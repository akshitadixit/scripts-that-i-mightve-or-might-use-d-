# producer.py that takes jobs from user and pushes to queue

import redis
import json
from uuid import uuid4
from job import Job

class Producer:
    def __init__(self, host='localhost', port=6379, db=0):
        self.__db = redis.Redis(host=host, port=port, db=db)
        self.name = 'queue'

    def push(self, job):
        print(f"Pushing: {job.name}")
        self.__db.rpush(self.name, json.dumps(job.__dict__))

    def create_job(self, job_text, job_script):
        job = {'_id': str(uuid4()), 'name': job_text, 'script': f'z_python/{job_script}'}
        self.push(Job(**job))

    def start(self):
        while True:
            job_data = input("Enter job name and script path: ")
            job_name, job_script = job_data.split()
            self.create_job(job_name, job_script)

if __name__ == '__main__':
    producer = Producer()
    try:
        producer.start()
    except KeyboardInterrupt:
        print("\b\bExiting")
