; faster coding refactored
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Coding schema

; Add coding schema to the array. Ensure use of numbering system as parsing for generating GUI checks for change in first string to signal new column. For example, all beginning "1" will be the first column, all beginning "2" the second column, etc.

coding := ["1 First example", "1a example",  "1b example", "1c example", "1d example", "1e example", "1f example", "1g example", "1h example", "1i example", "1j example", "1k example", "2 Second example", "2a example", "2b example", "2c example", "2d example", "2d1 example", "2e example", "2f example", "2g example", "2h example", "2i example", "2j example", "2k example", "2l example", "2m example", "2n example", "2x example", "3 Third example", "3a example", "3b example", "3c example", "3d example", "3e example", "3f example", "3g example", "3h example", "3i example"]

; GUI
space = y+5
columnspace = y+25

Gui, -caption ; removes Window from around GUI
Gui, Color, B
Gui, Font, S20 CWhite Bold, Verdana
Gui, Add, Text,, What to code selection at?
Gui, Font, S10 CWhite Bold, Verdana
Gui, Add, Text,%space%,
StringGetPos, EndofCode, % coding[1], %A_Space%
StringLeft, StartCode, % coding[1], EndofCode
Counter := 1
Loop % coding.Length()
{
    StringLeft, CurrentCode, % coding[A_Index], EndofCode
    if (StartCode = CurrentCode)
    {
        Gui, Add, Text, %space%, % coding[A_Index]
        Counter := Counter + 1
    }
    else
    {
        if (Counter > 25)
        {
            Gui, Font, S20 CWhite Bold, Verdana
            Gui, Add, Text,ys, %A_Space%
            Gui, Font, S10 CWhite Bold, Verdana
            Gui, Add, Text, %columnspace%, % coding[A_Index]
            StringGetPos, EndofCode, % coding[A_Index],  %A_Space%
            StringLeft, StartCode, % coding[A_Index], EndofCode
            Counter := 1
        }
        else
        {
            Gui, Add, Text,, % coding[A_Index]
            StringGetPos, EndofCode, % coding[A_Index],  %A_Space%
            StringLeft, StartCode, % coding[A_Index], EndofCode
            Counter := Counter + 1
        }
    }
}
Gui, Font, S20 CDefault Bold, Verdana
Gui, Add, Edit, r1 vInput,



; Coding

mode=0

#if (mode=0)
#NumpadEnter::
mode=1
MsgBox, Faster coding mode active, press Windows key plus NumPad Enter to exit.
SetNumLockState, Off
Return

#If

; SELECTION MODE

#if (mode=1)

NumpadLeft::^NumpadLeft
NumpadRight::^NumpadRight
NumpadPgUp::Send {NumpadUp 10}
NumpadPgDn::Send {NumpadDown 10}

;single code

NumpadEnter::
Send ^q
Gui, Show, x129 y141, Select code
mode=2
SetNumLockState, On
Return

;multi code

Enter::
Send ^q
Gui, Show, x129 y141, Select code
mode=3
SetNumLockState, On
Return

;Exit faster coding mode

#NumpadEnter::
mode=0
MsgBox, Exited faster coding mode.
Return

;Code at currently selected node

NumpadAdd::
Send ^{F9}
Return

#if


; handling input

#if (mode=2 or mode=3)

Escape::
Gui, Cancel
mode=1
WinActivate, OFFICEVD
send ^q
SetNumLockState, Off
Return

NumpadEnter::
Gui, Submit
Send +{end}{delete}
; Included above Send for situations of coding at multiple nodes as NVivo tends to lose the selection of full node name after switching focus to the select code GUI and back, this therefore ensures the box is clear for entering a new node.
InputLen := StrLen(Input)
IsMatched := 0
Loop % coding.Length()
{
    StringLeft, ToMatch, % coding[A_Index], InputLen
    if (ToMatch = Input)
    {
        StringLeft, Output, % coding[A_Index], 8
        IsMatched :=1
        Send %Output%
        ;Sleep 200
        Send {down}{enter}
        ; MsgBox, %Output%
        break
    }
}

if IsMatched = 0
{
    Send ^q
    MsgBox, Invalid selection - please try again.
    mode=1
    Input:=""
    GuiControl,,Input,%Input%
    WinActivate, OFFICEVD
    SetNumLockState, Off
}


Input:=""
GuiControl,,Input,%Input%
WinActivate, OFFICEVD

if (mode=2)
{
    Sleep, 1000
    Send ^q
    mode := 1
    SetNumLockState, Off
}

if (mode=3)
{
    Gui, Show, x129 y141, Select code
}

Return
#if

PrintScreen::ExitApp
