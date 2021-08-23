# https://stackoverflow.com/questions/64957982/how-to-pad-numbers-with-jq

def pad_left($len; $chr): (
    (tostring | length) as $l | 
    "\($chr * ([$len - $l, 0] | max) // "")\(.)"
);

def pad_left($len): (
    pad_left($len; " ")
);

def derive_sort_key: (
    split(".") | 
    [ 
        .[] | 
        pad_left(3; "0") 
    ] | 
    join("") 
);

def latest_summarized_python_dist: (
    .releases | 
        to_entries | 
        [ 
            .[] | 
            .key as $version | 
            (
                .value |
                .[] |
                select(.packagetype=="sdist")
            ) as $sdist | 
            {
                resource: $resource,
                version:$version, 
                url: $sdist.url, 
                sha256: $sdist.digests.sha256, 
                sort_key: ($version | derive_sort_key) 
            } 
        ] | 
        map(select(
            .sort_key | test("^[0-9]+$"; "g")
        )) |
        sort_by(.sort_key) |
        .[-1]
);

def transform_summarized_python_dist_into_brew_formula_def: (
    "\tresource \"\(.resource)\" do\n\t\turl \"\(.url)\"\n\t\tsha256 \"\(.sha256)\"\n\tend" 
    | sub("\t"; "  "; "g")
);

latest_summarized_python_dist | transform_summarized_python_dist_into_brew_formula_def