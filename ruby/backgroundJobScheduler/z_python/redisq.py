import redis

class RedisQueue:
    def __init__(self, name, namespace='queue', maxsize=10, **redis_kwargs):
        self.__db = redis.Redis(**redis_kwargs)
        self.key = f'{namespace}:{name}'
        self.last_pushed = None
        self.last_popped = None
        self.maxsize = maxsize

    def qsize(self):
        return self.__db.llen(self.key)

    def push(self, item):
        print(f"Pushing: {item}")
        self.last_pushed = item
        self.__db.rpush(self.key, item)

    def pop(self, block=True, timeout=None):
        if block:
            item = self.__db.blpop(self.key, timeout=timeout)
        else:
            item = self.__db.lpop(self.key)

        if item:
            item = item[1]

        self.last_popped = item
        return item

    def get_nowait(self):
        return self.get(False)


if __name__ == '__main__':
    # run until ctrl+c
    try:
        Q = RedisQueue('test', maxsize=10, host='localhost', port=6379, db=0)
        prev = 0
        while True:
            if Q.qsize() == 0 and prev != 0:
                print("-----------EMPTY-----------")
            elif Q.qsize() == Q.maxsize and prev != Q.maxsize:
                print("----------FULL----------")


            if Q.qsize() != prev:
                if Q.qsize() > prev:
                    print(f"PUSHED: {Q.last_pushed}")
                else:
                    print(f"POPPED: {Q.last_popped}")

            prev = Q.qsize()

    except KeyboardInterrupt:
        print('\b\bExiting')
