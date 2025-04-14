#Requires AutoHotkey v2.0
ShowTip(data, time := 1000) { ; Function to show a tooltip with the given data for a specified time
    ToolTip data ; Show the tooltip with the provided data
    Sleep time ; Wait for the specified time (default is 1000 ms)
    ToolTip ; Clear the tooltip
}
SendSleep(data, time := 20) { ; Function to send a key with a sleep time
    Send data ; Send the specified key
    Sleep time ; Wait for the specified time (default is 100 ms)
}
CopyCut(piMode := false) { ; Function to copy or cut the selected text to the clipboard
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
pasTe(data) { ; Function to paste the given data into the clipboard and send the paste command
    clipbackup := ClipboardAll() ; Backup clipboard
    A_Clipboard := data ; Set new data to clipboard
    Send('^v') ; Send the default paste command
    Loop ; Check repeatedly to see if the clipboard is still open
           if (A_Index > 20) ; If more than 20 tries, notify of failure
            return TrayTip(A_ThisFunc ' failed to restore clipboard contents.')
        else Sleep(100) ; Otherwise, wait another 100ms
    Until !DllCall('GetOpenClipboardWindow', 'Ptr')
    A_Clipboard := clipbackup ; Finally, restore original clipboard contents
}