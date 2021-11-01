#!/usr/bin/env python3

import argparse
import sys 
import json
import itertools
from hash import djb2x_hash


def grouper(iterable, n, fillvalue=None):
    "Collect data into non-overlapping fixed-length chunks or blocks"
    # https://docs.python.org/3/library/itertools.html
    # grouper('ABCDEFG', 3, 'x') --> ABC DEF Gxx
    args = [iter(iterable)] * n
    return itertools.zip_longest(*args, fillvalue=fillvalue)


# https://www.dynamodbguide.com/anatomy-of-an-item/
def translate_object_into_ddb_item(o:dict):
    if isinstance(o, dict):
        return {"M": {k: translate_object_into_ddb_item(v) for k, v in o.items()}}
    elif isinstance(o, set):
        if all([isinstance(x, str) for x in o]):
            return {"SS": o}
        elif all([isinstance(x, (int, float)) for x in o]):
            return {"NS": o}
        else:
            raise ValueError("Translation failed. Don't know how to deal with non numeric or string sets.")
    elif isinstance(o, list):
        return {
            "L": [
               translate_object_into_ddb_item(a) for a in o
            ]
        }
    elif isinstance(o, str):
        return {"S": o}
    elif isinstance(o, bool):
        return {"BOOL": o}
    elif isinstance(o, (int, float)):
        return {"N": str(o)}
    raise ValueError(f"Translation failed. Don't know how to deal with value of type {type(o)}.")
    

def append_hash_to_item(o:dict, key_to_hash:str, hash_key:str="hash"):
    o[hash_key] = djb2x_hash(o[key_to_hash])[2:]
    return o


def main(table_name, input_stream):
    resp = [
        {
            f"{table_name}": [
                {
                    "PutRequest": {
                        "Item": {
                            k: translate_object_into_ddb_item(v) 
                            for k, v in append_hash_to_item(
                                json.loads(line), "quote"
                            ).items()
                        }
                    }
                }
                for line in chunk
                if line
            ]
        }
        for chunk in grouper(input_stream.readlines(), 25, None)
    ]
    return resp


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Consume a stream of new-line delimited JSON and produce a file that is ready to be saved into dynamo using the aws cli.'
    )
    parser.add_argument(
        '-t', '--table', action='store', dest="table", type=str, required=True, help="Name of DynamoDB table records will be inserted into."
    )
    parser.add_argument(
        '-p', '--prefix', action='store', dest="prefix", type=str, required=True, help="Prefix of chunk files."
    )
    args = parser.parse_args()
    chunks = main(args.table, sys.stdin)
    for i, chunk in enumerate(chunks):
        output_file = f"{args.prefix}-{i}.json"
        with open(output_file, "w") as fh:
            json.dump(chunk, fh, indent=4)
        print(output_file)
