import time

def underline(s):
    # https://stackoverflow.com/questions/35401019/how-do-i-print-something-underlined-in-python
    return f"\033[4m{s}\033[0m"

def scroll(depth=0, emoji="🚣", max_width=30, speed=1, prefix_char="🌊"):
    # https://stackoverflow.com/questions/17391437/how-to-use-r-to-print-on-same-line/17391457
    if depth == max_width:
        return 
    prefix = underline(prefix_char*depth)
    print(f"{prefix}{underline(emoji)}",end="\r")
    time.sleep(speed)
    scroll(depth=depth+1, emoji=emoji, max_width=max_width, speed=speed)

scroll(speed=0.05)

