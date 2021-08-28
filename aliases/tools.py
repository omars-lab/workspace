#!/usr/bin/env python3

def transform_link(original_link): 
  parsed_link = p.urlparse(original_link)
  # print(parsed_link)
  link_params = p.parse_qs(parsed_link.query)
  # print(link_params)
  if link_params["path"]:
    relative_path = link_params["path"][0].replace("/Locations/personalbook/", "")
    short_link_name = relative_path.replace(" ", "").replace(",", "").replace(".md", "")
    return (f'[ [[{relative_path}]] ]({original_link})')
    # return (f'[[[{relative_path}]]]({short_link_name})\n[{short_link_name}]: {original_link}')
  return ""

try:
  import urllib.parse as p
  import sys
  for link in sys.stdin.readlines():
    # print(link)
    print(transform_link(link))
except Exception as e:
  print(e)
