import threading

import ctypes
import time

import os
import threading

import ctypes
import time

class twe(threading.Thread):
    def __init__(self, group=None, target=None, name=None):
        threading.Thread.__init__(self, group=group, target=target, name=name)
        return

    def run(self):
        self._target()

def request_func():
    try:
        start = time.time()
        os.system('./../redis-get_1000.sh > /dev/null')
        # thp = float(os.popen('./redis-get_1000.sh').read().replace('"','').replace('GET','').replace(',','').replace('\n','')) # throughput
        left = 1-time.time()+start
        print(1000/(1-left))
    except:
          print('0')

def main():
    os.system('./../redis-set_1000000.sh > /dev/null')
    for i in range(50):
        start = time.time()
        x = twe(name = 'Client Thread', target=request_func)
        x.start()
        x.join(1)
        left = 1-time.time()+start
        if 0<left and left < 1 :
            time.sleep(left)

if __name__ == '__main__':
    main()
