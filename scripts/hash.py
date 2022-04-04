#!/usr/bin/env python3

# * [ ] Read up on hashing strings
# 	* [ ] What are the different ways to hash a string
# 	* [ ] https://cp-algorithms.com/string/string-hashing.html
# 	* [ ] http://www.cse.yorku.ca/~oz/hash.html
# 	* [ ] https://gist.github.com/mengzhuo/180cd6be8ba9e2743753
# 	* [ ] https://brilliant.org/wiki/hash-tables/
# 	* [ ] https://stackoverflow.com/questions/1579721/why-are-5381-and-33-so-important-in-the-djb2-algorithm
# 	* [ ] https://stackoverflow.com/questions/10696223/reason-for-5381-number-in-djb-hash-function/13809282#13809282

def djb2x_hash(string):
    """
    Implementation from: https://brilliant.org/wiki/hash-tables/
    """
    hash = 5381
    byte_array = string.encode('utf-8')

    for byte in byte_array:
        # the modulus keeps it 32-bit, python ints don't overflow
        hash = ((hash * 33) ^ byte) % 0x100000000

    return hex(hash)

if __name__ == "__main__":
    hash = djb2x_hash
    import sys
    for arg in sys.argv[1:]:
        print(hash(arg))
