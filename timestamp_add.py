"""
Add timestamp to an arbitrary json from stdin
- timestamp comes from environment variable `TS`
- timestamp is in UTC seconds since unix epoch
- dump json object to stdout
"""
import os
import sys
import json

data = json.loads(sys.stdin.read())
data.update({"timestamp": os.environ["TS"]})
sys.stdout.write(json.dumps(data))
