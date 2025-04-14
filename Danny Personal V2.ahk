; =============================
; AHK Script for Personal Use
; ============================
; SETTINGS
#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode 'Mouse', 'Window'
SetNumLockState 'On'
SetNumLockState 'AlwaysOn'
SetScrollLockState 'Off'
SetScrollLockState 'AlwaysOff'
SetTitleMatchMode '2' ; Set title match mode to 2 for partial matches
SetTitleMatchMode 'Slow' ; Slow mode for partial matches
Persistent ; Keep the script running
KeyHistory 500 ; Show the last 500 key presses in the Key History window

; =============================
; LIBRARIES
#Include 'C:\Users\Daniel.Riolo\OneDrive - MM Enterprises USA LLC\Documents\GitHub\TapHoldManager\AHK v2\Lib\TapHoldManager.ahk'
#Include 'C:\Users\Daniel.Riolo\OneDrive - MM Enterprises USA LLC\Documents\GitHub\TapHoldManager\AHK v2\Lib\InterceptionTapHold.ahk'
#Include 'C:\Users\Daniel.Riolo\OneDrive - MM Enterprises USA LLC\Documents\GitHub\AHK-Personal\Lib\DannysLib.ahk' ; Include the custom library for personal functions
; #Include 'C:\Users\Daniel.Riolo\OneDrive - MM Enterprises USA LLC\Documents\GitHub\TapHoldManager\AHK v2\Lib\AutoHotInterception.ahk'

; ============================
; GLOBAL VARIABLES
global thm := TapHoldManager() ; Create an instance of the TapHoldManager class
global Layer4 := false ; Initialize the Layer4 variable
global g_DoubleAlt := false ; Initialize the g_DoubleAlt variable

; ============================
; HOTSTRINGS
:*:@@::danielriolo86@gmail.com
:*:asd::autohotkey V2 

; ============================
; HOTKEYS
Insert::{  ; Save and Reload the script
    if InStr( WinGetTitle('A'), 'Visual Studio Code') {
        SendSleep '^s' ; Save the file
        ShowTip('AHK Saved & Reloaded') ; Show the tooltip for 1 seconds
    } else {
        ShowTip('AHK Reloaded') ; Show the tooltip for 1.5 seconds
    }
    Reload
    return  
}
~Esc::{  ; Reload/ Suspend / Exit the script, Send Esc key
    thm.Add("Esc", ReloadSuspendQuitFunc) ; Add a tap hold event for key 'Esc'
    ReloadSuspendQuitFunc(isHold, taps, state) { ; Function to handle the tap hold event
        if (taps == 1) { ; If the key is tapped twice
            ShowTip('AHK Reloaded') ; Show the tooltip for 1 second
            Reload
        }else if (taps == 2) { ; If the key is tapped twice
            ShowTip('AHK Suspended') ; Show the tooltip for 1 second
            Suspend -1 ; Suspend the script
        } else if (taps == 3) { ; If the key is tapped three times
            ShowTip('AHK Exiting') ; Show the tooltip for 1 second
            ExitApp() ; Exit the script
        }
    }
}
F13::{  ; (Circle button) Toggles the "Always On Top" state for the active window
    ActiveWindowID := WinGetID('A')
    WinSetAlwaysOnTop -1, ActiveWindowID ; Toggles the "Always On Top" state for the active window
    return
}
!LButton::{ ; (Alt + Left Click), Drag and Move the window
    global g_DoubleAlt  ; Declare it since this hotkey function must modify it.
    ; if g_DoubleAlt{
    ;     MouseGetPos ,, &KDE_id
    ;     ; This message is mostly equivalent to WinMinimize,
    ;     ; but it avoids a bug with PSPad.
    ;     PostMessage 0x0112, 0xf020,,, KDE_id
    ;     g_DoubleAlt := false
    ;     return
    ; }
    ; Get the initial mouse position and window id, and
    ; abort if the window is maximized.
    MouseGetPos &KDE_X1, &KDE_Y1, &KDE_id
    if WinGetMinMax(KDE_id)
        return
    ; Get the initial window position.
    WinGetPos &KDE_WinX1, &KDE_WinY1,,, KDE_id
    Loop
    {
        if !GetKeyState("LButton", "P") ; Break if button has been released.
            break
        MouseGetPos &KDE_X2, &KDE_Y2 ; Get the current mouse position.
        KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
        KDE_Y2 -= KDE_Y1
        KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
        KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
        WinMove KDE_WinX2, KDE_WinY2,,, KDE_id ; Move the window to the new position.
    }
}
NumLock::{ ;Launch the calculator
    Run 'calc.exe' ; Launch the calculator
}
; ============================
; APP SPECIFIC HOTKEYS
; ---------
; Microsoft Excel
#HotIf WinActive('Microsoft Excel')
    ; Paste Values
    ; ^v::Send '^!v'  ; Paste values in Excel (ctrl + alt + v)
    ^v::{  ; Paste Values in Excel (Alt + h + v + v)
        SendSleep '!h' ; Open the Paste Special menu
        SendSleep '!v' ; Select Paste Values
        SendSleep '!v' ; Confirm the selection
    }
#HotIf ; End Excel hotkey block

; ---------
; Notepad
#HotIf WinActive('Notepad') ; Define hotkeys that are active only when Notepad is the active window
    F15:: Send 'Danny is the bomb!' ; (Square button) Send a message to Notepad
    F16:: Send 'Danny is the best!' ; (X button) Send a message to Notepad
#HotIf ; End Notepad hotkey block

; ---------
; Visual Studio Code
#HotIf WinActive('Visual Studio Code')

#HotIf ; End Visual Studio Code hotkey block

; ============================
; Extra keyboard layers
; ---------
; Layer 4: Double tap RWin
~RWin:: {
    thm.Add("RWin", L4state) ; Add a tap hold event for key 'Rwin'
    global Layer4 := false ; Initialize the Layer4 variable
    L4state(isHold, taps, state) { ; Function to handle the tap hold event
        global Layer4 ; Declare the Layer4 variable as global
        if (taps == 2) { ; If the key is tapped twice
            Layer4 := !Layer4 ; Toggle the Layer4 variable
            ShowTip('Layer 4 is ' . (Layer4 ? 'ON' : 'OFF')) ; Show the tooltip for 1 second
        } else { ; If the key is not tapped twice, send a normal tap event
            Send '{RWin}'
        }
    }
}
#HotIf Layer4 ; Define hotkeys that are active only when Layer4 is true
    Media_Play_Pause::Send '{F8}'
#HotIf ; End conditional hotkey block 

; ============================
; Mouse Jiggler
global isJiggling := false ; Initialize the isJiggling variable
F16::{  ; (X button) Mouse Jiggler
    global isJiggling := isJiggling ? false : true ; Toggle the jiggling state
    if (isJiggling) {
        SetTimer MoveMouse, 1000 ; Move the mouse every second
        ShowTip('Mouse Jiggler is ' . (isJiggling ? 'ON' : 'OFF')) ; Show the tooltip for 1 second
    } else {
        SetTimer MoveMouse, 0 ; Stop the mouse movement
        ShowTip('Mouse Jiggler is ' . (isJiggling ? 'ON' : 'OFF')) ; Show the tooltip for 1 second
    } 
    MoveMouse() {   ; Function to move the mouse for the jiggler
        global isJiggling := isJiggling ? false : true ; Toggle the jiggling state
        If(A_TimeIdle > 15000) { ; Check if the mouse has been idle for more than 60 seconds
            ; Move the mouse up and down by 1 pixel
            ; MouseMove 0, .5, 0, 'R' ; Move the mouse down by 1 pixel
            ; MouseMove 0, -.5, 0, 'R' ; Move the mouse back up by 1 pixel
            ; Randomly move the mouse by a small amount to simulate jiggling
            xOffset := Random(-10, 10) ; Randomly move horizontally +/- (1-10) pixels
            yOffset := Random(-10, 10) ; Randomly move vertically +/- (1-10) pixels
            MouseMove xOffset, yOffset, 0, 'R' ; Move the mouse by the random offsets
        }
    }
}
