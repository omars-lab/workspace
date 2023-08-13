# https://rosettacode.org/wiki/URL_decoding#jq
# https://stackoverflow.com/questions/53937411/what-is-the-format-in-jq-for-calling-a-custom-module
# jq -n 'import "lib" as lib; "http%3A%2F%2Ffoo%20bar%2F" | lib::url_decode'

# Emit . and stop as soon as "condition" is true.
def until(condition; next):
  def u: if condition then . else (next|u) end;
  u;

def url_decode:
  # The helper function converts the input string written in the given
  # "base" to an integer
  def to_i(base):
    explode
    | reverse
    | map(if 65 <= . and . <= 90 then . + 32  else . end)   # downcase
    | map(if . > 96  then . - 87 else . - 48 end)  # "a" ~ 97 => 10 ~ 87
    | reduce .[] as $c
        # base: [power, ans]
        ([1,0]; (.[0] * base) as $b | [$b, .[1] + (.[0] * $c)]) | .[1];

  .  as $in
  | length as $length
  | [0, ""]  # i, answer
  | until ( .[0] >= $length;
      .[0] as $i
      |  if $in[$i:$i+1] == "%"
         then [ $i + 3, .[1] + ([$in[$i+1:$i+3] | to_i(16)] | implode) ]
         else [ $i + 1, .[1] + $in[$i:$i+1] ]
         end)
  | .[1];  # answer

# https://stackoverflow.com/questions/40366520/replacing-underscores-in-json-using-jq
def compressPath: (
  gsub(".*/git/"; "") 
  | gsub(".*/.noteplan/"; "noteplan/") 
  | gsub(".*/Locations/"; "iawriter/") 
  | gsub(".*/Dropbox/"; "dropbox/") 
  | gsub(" or "; "Or") 
  | gsub(" "; "") 
  | gsub(".md$"; "") 
  | gsub(".txt$"; "") 
  | gsub( "-(?<a>[a-z])"; .a|ascii_upcase) 
  | gsub( "-"; "") 
  | gsub( "/(?<a>[a-z])"; "/\(.a|ascii_upcase)") 
  | gsub( "/[Oo]verview"; "") 
  | sub("^(?<a>[a-z])"; .a|ascii_upcase)
  | gsub( "/./"; "/") 
  | gsub( "/"; ".") 
  | gsub( "(?<a>[^a-zA-Z0-9])"; "") 
  # | gsub( "(?<a>[^a-zA-Z0-9])"; "`\(.a)") 
);

def replaceSingleQuote:(
  gsub("[']"; "") 
  | gsub("/./"; "/")
);

def deriveNodeCipher:(
  . as $link 
  | [
    "CREATE (\($link.fileName):File {name: '\($link.fileName)', path:'\($link.file|replaceSingleQuote)'})",
    "CREATE (\($link.pointerName):File {name: '\($link.pointerName)', path:'\($link.pointer|replaceSingleQuote)'})"
  ] 
  | .[]
);

def deriveRelCipher:(
  . as $link 
  | [
    "CREATE (\($link.fileName))-[:REFERENCES {line:'\($link.lineWithLink)', link: '\($link.link|replaceSingleQuote)', type: '\($link.linkType)'}]->(\($link.pointerName))"
  ] 
  | .[]
);