# Link Reformatter

* Links carry within them tons of data ... this plan is about reformatting links in my notes such that their pressence carrys the necessary context with regards to the document that contains them.

```
curl 'https://youtube.com/oembed?url=https://www.youtube.com/watch?v=kshboJxmU7k&format=json' | jq
{
  "title": "How to be a more creative person | Bill Stainton | TEDxStanleyPark",
  "author_name": "TEDx Talks",
  "author_url": "https://www.youtube.com/@TEDx",
  "type": "video",
  "height": 113,
  "width": 200,
  "version": "1.0",
  "provider_name": "YouTube",
  "provider_url": "https://www.youtube.com/",
  "thumbnail_height": 360,
  "thumbnail_width": 480,
  "thumbnail_url": "https://i.ytimg.com/vi/kshboJxmU7k/hqdefault.jpg",
  "html": "<iframe width=\"200\" height=\"113\" src=\"https://www.youtube.com/embed/kshboJxmU7k?feature=oembed\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" referrerpolicy=\"strict-origin-when-cross-origin\" allowfullscreen title=\"How to be a more creative person | Bill Stainton | TEDxStanleyPark\"></iframe>"
}

```

```
pbpaste | sed 's/[*]\s*//g' | xargs -n 1 echo | xargs -I {} sh -c "curl -s 'https://youtube.com/oembed?url={}&format=json' | jq -r --arg url '{}' '\"* [\(.title)](\(\$url)) by [\(.author_name)](\(.author_url))\"' "

```

```
pbpaste | sed 's/[*]\s*//g' | xargs -n 1 echo | xargs -I {} sh -c 'curl -s "https://youtube.com/oembed?url={}&format=json" | jq -r --arg url "{}" "[\(.title)](\($url))"'

```

