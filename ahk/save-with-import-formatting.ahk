; Program: VS Code
; What it does: Scrolls to the top of the file, aligns the Typescript imports by "from ", and then saves the file.
; Requires: "Better Align" plugin by wwm

;Ctrl + shift + s
^+s::
Send,{Ctrl down}{Home}{Ctrl up}
Sleep,100
Send,{Ctrl down}{Shift down}={Ctrl up}{Shift up}
Sleep, 100
Send,from
Send,{Space}
Sleep, 100
Send,{Enter}
Sleep, 100
Send,{Ctrl down}s{Ctrl up}
Sleep, 100
Send,{Alt down}{Left}{Alt up}