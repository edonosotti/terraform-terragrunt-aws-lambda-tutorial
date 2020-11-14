import os
import logging

LOG_FORMAT='%(asctime)-15s - %(levelname)-8s - @%(module)-s:%(lineno)-s - %(message)s'
logging.basicConfig(format=LOG_FORMAT, level=os.getenv('LOG_LEVEL', 'ERROR'))

from core import mathutils

def get_values():
    return mathutils.get_zeros()

# Entry point for Lambda execution
def handler(event, context):
    logging.info(get_values())

# Entry point for local execution
if __name__ == "__main__":
    handler({}, {})
