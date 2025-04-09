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
; SetWorkingDir 'C:\Users\Daniel.Riolo\OneDrive - MM Enterprises USA LLC\Documents\AutoHotkey\Lib'
#Include 'C:\Users\Daniel.Riolo\OneDrive - MM Enterprises USA LLC\Documents\GitHub\TapHoldManager\AHK v2\Lib\TapHoldManager.ahk'
#Include 'C:\Users\Daniel.Riolo\OneDrive - MM Enterprises USA LLC\Documents\GitHub\TapHoldManager\AHK v2\Lib\InterceptionTapHold.ahk'
global thm := TapHoldManager() ; Create an instance of the TapHoldManager class
; #Include 'C:\Users\Daniel.Riolo\OneDrive - MM Enterprises USA LLC\Documents\GitHub\TapHoldManager\AHK v2\Lib\AutoHotInterception.ahk'

; ============================
; HOTSTRINGS
:*:@@::danielriolo86@gmail.com

; ============================
; HOTKEYS
Insert:: {  ; Save and Reload the script}
    if InStr( WinGetTitle('A'), 'Visual Studio Code') {
        Send '^s' ; Save the file
        Sleep 20 ; Wait for 20 milliseconds
        ShowTip('AHK Saved & Reloaded') ; Show the tooltip for 1 seconds
    } else {
        ShowTip('AHK Reloaded') ; Show the tooltip for 1.5 seconds
    }
    Reload
    return  
}
~Esc::{  ; Reload/ Suspend / Exit the script
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
F13::{  ; Toggles the "Always On Top" state for the active window
    ActiveWindowID := WinGetID('A')
    WinSetAlwaysOnTop -1, ActiveWindowID ; Toggles the "Always On Top" state for the active window
    return
}
; ============================
; APP SPECIFIC HOTKEYS
; ---------
; Visual Studio Code
HotIfWinActive(InStr('Visual Studio Code', WinGetTitle('A')))
F15::Send '^s' ; Save the file in Visual Studio Code
HotIfWinActive() ; End conditional hotkey block
; ============================
; MACROS
F16::{  ; Mouse Jiggler
    global isJiggling := isJiggling ? false : true ; Toggle the jiggling state
    if (isJiggling) {
        SetTimer MoveMouse, 1000 ; Move the mouse every second
        ShowTip('Mouse Jiggler is ' . (isJiggling ? 'ON' : 'OFF')) ; Show the tooltip for 1 second
    } else {
        SetTimer MoveMouse, 0 ; Stop the mouse movement
        ShowTip('Mouse Jiggler is ' . (isJiggling ? 'ON' : 'OFF')) ; Show the tooltip for 1 second
    }
    return
}
; ============================
; FUNCTIONS
ClipCopy(piMode := false) { ; Function to copy or cut the selected text to the clipboard
    ; Parameters:
    ;   piMode (optional): 
    ;       - false (default): Copies the selected text to the clipboard without removing it.
    ;       - true: Cuts the selected text to the clipboard.
    ; Returns:
    ;   The text that was copied or cut.
    clpBackup := ClipboardAll() ; Backup the current clipboard content
    Clipboard := '' ; Clear the clipboard

    sCopyKey := piMode ? 'x' : 'c' ; Determine the key to send based on piMode
    Send '^' . sCopyKey ; Send Ctrl+X or Ctrl+C to cut or copy the selected text
    ClipWait 1 ; Wait for the clipboard to contain data
    sRet := ClipboardAll() ; Store the copied or cut data in a variable
    Clipboard := clpBackup ; Restore the original clipboard content
    return sRet ; Return the copied or cut data
}
ClipPaste(data) {   ; Function to paste data from the clipboard
    ; Parameters:
    ;     data - The data to be pasted. This will temporarily replace the current clipboard content.

    ; Functionality:
    ; 1. Backs up the current clipboard content using ClipboardAll().
    ; 2. Sets the clipboard to the provided data.
    ; 3. Sends the default paste command (Ctrl+V).
    ; 4. Waits until the clipboard is no longer in use by checking the open clipboard window.
    ;    - If the clipboard remains open for more than 20 attempts (2 seconds), the function exits.
    ; 5. Restores the original clipboard content after the paste operation.

    ; Note:
    ; - This function ensures that the original clipboard content is preserved after the operation.
    ; - The loop ensures that the clipboard is not in use before restoring the original content.

    clipbackup := ClipboardAll() ; Backup clipboard
    A_Clipboard := data ; Set new data to clipboard
    Send('^v') ; Send the default paste command
    Loop ; Check repeatedly to see if the clipboard is still open
           if (A_Index > 20) ; If more than 20 tries, Exit function
               Exit 
           else Sleep(100) ; Otherwise, wait another 100ms
    Until !DllCall('GetOpenClipboardWindow', 'Ptr') ; Wait until the clipboard is closed
    A_Clipboard := clipbackup ; Finally, restore original clipboard contents
}
ShowTip(data, time := 1000) { ; Function to show a tooltip with the given data for a specified time
    ToolTip data ; Show the tooltip with the provided data
    Sleep time ; Wait for the specified time (default is 1000 ms)
    ToolTip ; Clear the tooltip
}
MoveMouse() {   ; Function to move the mouse for the jiggler
    global isJiggling := isJiggling ? false : true ; Toggle the jiggling state
    If(A_TimeIdle > 60000) { ; Check if the mouse has been idle for more than 60 seconds
        ; MouseMove 0, 1, 0, 'R' ; Move the mouse down by 1 pixel
        ; MouseMove 0, -1, 0, 'R' ; Move the mouse back up by 1 pixel
        xOffset := Random(-10, 10) ; Randomly move left or right by 10 pixels
        yOffset := Random(-10, 10) ; Randomly move up or down by 10 pixels
        MouseMove xOffset, yOffset, 0, 'R' ; Move the mouse by the random offsets
    }
    return
}
; ============================
; Extra keyboard layers
; ---------
; Layer 4:
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
; CHANGE HIGHLIGHTED TEXT TO ALL CAPS WITH CAPSLOCK

