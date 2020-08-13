
def zip:
  transpose | map( { (.[0]): .[1] } ) | reduce .[] as $item ({}; . + $item) ;

.table as $r 
  | ( $r.thead.tr.th | [ ( .[] | .[("#text")] ) ] ) as $headers 
  | ( $r.tbody.tr | [ ( .[] | .td | [ .[] | .[("#text")] ] ) ] ) as $values 
  | $values 
  | (reduce .[] as $item ([]; . + [ [$headers, $item] | zip ] ) )
