#!/usr/bin/osascript

(*
  Resources considered:
  - Command Line Args: http://hints.macworld.com/article.php?story=20050523140439734
  - https://mindnode.cdn.prismic.io/mindnode/777fccf1-11e6-4bde-afc9-01320c5e0248_mindnode_for_macos_userguide.pdf
  - https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/conceptual/ASLR_lexical_conventions.html#//apple_ref/doc/uid/TP40000983-CH214-SW8
  - http://hints.macworld.com/article.php?story=20050523140439734
  - POSIX paths not same as Finder paths: https://www.macscripter.net/viewtopic.php?id=45910
*)

(* 
    set folderPath to choose folder
    set theDialogText to "The curent date and time is " & (current date) & "." & (item 1 of argv)
    display dialog theDialogText 
    set folderPath to (POSIX file (item 1 of argv))
    set folderPath to (POSIX file (item 1 of argv))
*)

on run argv
  set fileExtension to "mindnode"
  tell application "/Applications/MindNode.app"
    repeat with mindNodeFile in argv
      open mindNodeFile
      set mindNodeDocument to document 1
      set fileName to POSIX path of mindNodeFile
      set baseName to (characters 1 thru -((count of fileExtension) + 2) of fileName) as string
      set exportFile to ((baseName & ".png") as POSIX file)
      tell mindNodeDocument to export to exportFile as PNG
      close window 1 without saving
    end repeat
  end tell
end run
