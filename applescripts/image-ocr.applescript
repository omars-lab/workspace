use framework "Vision"
use framework "Foundation"
use framework "AppKit"

on run argv
    set imagePath to item 1 of argv
    
    -- Get image content
    set theImage to current application's NSImage's alloc()'s initWithContentsOfFile:imagePath
    
    if theImage is missing value then
        error "Failed to load image: " & imagePath
    end if
    
    -- Set up request handler using image's raw data
    set requestHandler to current application's VNImageRequestHandler's alloc()'s initWithData:(theImage's TIFFRepresentation()) options:(current application's NSDictionary's alloc()'s init())
    
    -- Initialize text request with accurate recognition level
    set theRequest to current application's VNRecognizeTextRequest's alloc()'s init()
    theRequest's setRecognitionLevel:(current application's VNRequestTextRecognitionLevelAccurate)
    
    -- Perform the request and get the results
    requestHandler's performRequests:(current application's NSArray's arrayWithObject:theRequest) |error|:(missing value)
    set theResults to theRequest's results()
    
    -- Obtain and return the string values of the results
    set theText to {}
    if theResults is not missing value then
        repeat with observation in theResults
            set topCandidates to observation's topCandidates:1
            if (count of topCandidates) > 0 then
                set candidateText to (topCandidates's firstObject()'s |string|() as text)
                if candidateText is not "" then
                    copy candidateText to end of theText
                end if
            end if
        end repeat
    end if
    
    -- Join text with spaces and return
    set AppleScript's text item delimiters to " "
    set resultText to theText as text
    set AppleScript's text item delimiters to ""
    
    return resultText
end run

