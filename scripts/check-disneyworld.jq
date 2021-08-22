.[] 
| ( 
	.parks = [ 
		.parks | 
		.[] | ( 
			tostring as $code | 
			{ 
				"80007823": "Animal Kingdom", 
				"80007838": "Epcot", 
				"80007944": "Magic Kingdom", 
				"80007998": "Hollywood Studios"
			} | 
			getpath([$code]) 
		) 
		] 
) | (
	. as $date 
	| .parks 
	| .[] 
	| [$date.date, .] 
	| @csv 
)
