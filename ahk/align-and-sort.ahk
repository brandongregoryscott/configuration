; Program: VS Code
; What it does: Aligns the current selection and then sorts it.
; Requires: "Align" plugin by Steve8708, "Sort lines" by Daniel Imms, and lines selected

;Ctrl + shift + a
^+a::
Send,{Ctrl down}{Alt down}a{Alt up}{Ctrl up}
Sleep, 100
Send,{F1}
Sleep, 100
Send, Sort lines (natural)
Sleep, 100
Send, {Enter}