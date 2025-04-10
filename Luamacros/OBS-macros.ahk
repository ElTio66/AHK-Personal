; ===== DO NOT DELETE ANYTHING BELOW THIS LINE =================
; ==============================================================

#NoEnv
SendMode Input
#InstallKeybdHook
#UseHook On
#SingleInstance force ;only one instance of this script may run at a time!
#MaxHotkeysPerInterval 2000
#WinActivateForce ;https://autohotkey.com/docs/commands/_WinActivateForce.htm
DetectHiddenWindows, On
SetWorkingDir %A_ScriptDir%


; ======================= AYLAD'S INTRO ========================
; This is mostly based on the work of others. I can't take credit for the underlying code.
; All I've really done is make it more user-friendly for non-coders to get started.
; All original credits are intact at the end of this file, typos included.

; ======================= DISCLAIMER ===========================
; I accept no responsibility for any consequences of using this file.
; This is especially true if you downloaded it from any source over which I have no control.
; I AM NOT A PROFESSIONAL CODER. USE AT YOUR OWN RISK.
; URLs included in the original credits are not conrolled by me and I cannot vouch for them.

; ==============================================================
; ======================= INSTRUCTIONS =========================
; ==============================================================

; NOTE: THIS SCRIPT IS INTENDED TO WORK WITH LUAMACROS. IF LUAMACROS ISN'T RUNNING, THIS WON'T WORK.
; Also, THIS SCRIPT MUST BE RUNNING to use it.

; All files that you downloaded from me must be in the same folder.

; I recommend you NOT edit this script yourself. Activate the GUI with Ctrl+Alt+Shift+N for
; new hotkeys or Ctrl+Alt+Shift+S for new soundboard sounds.

; If you do edit this file directly:

; Pay attention to secion headings. Don't delete anything that tells you not to delete it.

; Have a list of your OBS hotkeys handy. There are a few limitations here:
; 1. You can't include the Windows key in your hotkeys.
; 2. OBS, in my experience, gets some key combos confused with each other. TEST EVERYTHING BEFORE CONTINUING.
; 3. Ctrl+Alt+Shift+N and Ctrl+Alt+Shift+S (on your main keyboard) are reserved for this script.
; 4. The Escape key on your macro keyboard is reserved for this script.
; 5. The Pause/Break key on your main keyboard is reserved for this script.

; == TO CREATE A NEW HOTKEY ==

; Go down below the line that says "ADD YOUR HOTKEY CODE BELOW THIS LINE" and click in a nice big blank area.

; Press Ctrl+Alt+Shift+N on your main keyboard.

; Press the key on your macro keyboard that you want to trigger your macro.

; Enter a description of what the hotkey does (ex. "Switch to BRB screen") in the top box.

; Enter the hotkey in the lower box.

; Click "Add Another" if you want to make more hotkeys after this one, or "Close" if this is your last one.

; == TO DELETE A HOTKEY == 

; Back up a copy of this file just in case.

; Find the correct chunk of code, CAREFULLY select it ALL, and delete it.

; Be careful not to delete code from some other chunk or to leave code that you meant to delete.

; == TO EDIT A HOTKEY ==

; There's not really an edit function here. Delete that hotkey's code (see above) and start fresh.

; == AFTER CREATING, DELETING, EDITING, ETC ANY HOTKEY ==

; Be sure to save this file!
; If LuaMacros is running correctly, you should be able to hit Escape on your macro keyboard to reload this script.
; Your new hotkeys WILL NOT WORK UNTIL YOU RELOAD!

; ==============================================================
; ======================= END OF INSTRUCTIONS ==================
; ==============================================================

#IfWinActive ;---- This will allow for everything below this line to work in ANY application.

gosub launchLuaMacros ; Runs LuaMacros on script startup.

Pause::
launchLuaMacros:
Process, Exist, LuaMacros.exe
if (ErrorLevel)
{
  ;Process, Close, %ErrorLevel% ; originally let you toggle LuaMacros on/off. Disabled now.
}
else
{
  MsgBox, 4,, Would you like to start LuaMacros?
  IfMsgBox, Yes
  {
    Run *RunAs LuaMacros.exe MacroBoard-aylad.lua -r ; admin-runs LuaMacros, loads the correct lua script
    Sleep 2000
  }
}
Return

~F24::
FileRead, key, keypressed.txt

if (key = "escape")
{
  file := FileOpen("keypressed.txt", "w")
  file.Write("") ; Prevents escape from being assigned as a hotkey
  Reload
  Sleep 1000 ; If successful, the reload will close this instance during the Sleep.
  return
}
; ==============================================================
; ===== DO NOT DELETE ANYTHING ABOVE THIS LINE ================= 

; "Code below marker" below shows the script where to insert new hotkey code. DO NOT ALTER

; The triple-slash markers in the hotkey code blocks show the script where to edit/remove
; each hotkey's code. DO NOT ALTER

; ===== ADD YOUR HOTKEY CODE BELOW THIS LINE ===================codebelowmarker
 








; ===== YOUR HOTKEY CODE SHOULD ALL BE ABOVE THIS LINE =========

; ===== DO NOT DELETE ANYTHING BELOW THIS LINE =================
; ==============================================================


Return ;from luamacros F24

; SELF-WRITING CODE WOOHOO ============================================

; Code to insert or edit new hotkeys

^!+n::
nextkey:
Gui, Add, Text,, `n `n Press the key on your macro keyboard that you want to bind.`n `n
Gui, Add, Text,, Please enter the hotkey description:
Gui, Add, Edit, vComboName
Gui, Add, Text,, Please enter the hotkey combination:
Gui, Add, Hotkey, vCombo
Gui, add, button, w70 gnext, Add Another
Gui, add, button, Default w70 x+10 gexit, Close
Gui, add, button, w70 x+10 gCancel, Cancel
Gui, Show

Return

; called if you've indicated you want to add more than one hotkey

next:
gosub hksubmit ; first it submits the hotkey you just created
sleep 2000
gosub nextkey ; then reloads the gui
Return

; called when you're done adding hotkeys

exit:
gosub hksubmit ; submits the hotkey you just created
sleep 1000
Reload ; reloads this script for immediate use of the new hotkey
Return

hksubmit:
{


  Gui, Submit
  Gui, Destroy


  validkey := StrLen(key) ; checks to make sure there's a macro key to assign the hotkey to
  if(validkey)
  {

    ; these three lines check to see what modifier keys are involved

    UsedCtrl := InStr(Combo, "^") 
    UsedAlt := InStr(Combo, "!")
    UsedShift := InStr(Combo, "+")

    ; initialize the necessary variables

    MacroComboDown := ""
    MacroComboUp := ""
    MacroCheckKey := Combo

    ; parse the input string (from the dialog box) to determine what your macro is gonna be
  
    if(UsedCtrl)
    {
      MacroComboDown .= "{Ctrl down}"
      MacroComboUp .= "{Ctrl up}"
      MacroCheckKey := StrReplace(MacroCheckKey, "^")
    }  
    if(UsedAlt)
    {
      MacroComboDown .= "{Alt down}"
      MacroComboUp .= "{Alt up}"
      MacroCheckKey := StrReplace(MacroCheckKey, "!")
    }  
    if(UsedShift)
    {
      MacroComboDown .= "{Shift down}"
      MacroComboUp .= "{Shift up}"
      MacroCheckKey := StrReplace(MacroCheckKey, "+")
    }

    ; prepare the code block for your hotkey
    ; places where I'm concatenating strings are mostly to avoid unexpected behavior with the accursed regex code
    ; look I'm not a coder but it works okay, okay?

    insertscript := "`n `n; /"
    insertscript .= "//" . key . " ============ Begin " . ComboName . " ================ `n"
    insertscript .= "else if (key = """ . key . """) `n"
    insertscript .= "{ `n"
    insertscript .= "  Send, " . MacroComboDown . "{" . MacroCheckKey . " down} `n"
    insertscript .= "  Sleep 60 `n"
    insertscript .= "  Send, " . MacroComboUp . "{" . MacroCheckKey . " up} `n"
    insertscript .= "} `n"
    insertscript .= "; ================ End " . ComboName . " ============= " . key . "/// `n `n"

    editingregex := "; //" . "/" . key
    editingregex .= ".+?" . key . "///"

    FileRead, scriptcontents, OBS-macros.ahk ; load the contents of this script for editing

    updatingscript := RegExMatch(scriptcontents, editingregex)
    if(updatingscript)
    {

      ; replace an existing code block

      fixedscript := RegExReplace(scriptcontents, editingregex, insertscript,, 1)
    }
    else
    {

      ; insert a new code block

      codebelowmarker := "=codebelow" . "marker"
      insertedcode := codebelowmarker . insertscript
      fixedscript := RegExReplace(scriptcontents, codebelowmarker, insertedcode,, 1)
    }

    file := FileOpen("OBS-macros.ahk", "w")
    file.Write(fixedscript)
    file.Close()
  
  }
  else
  {
    MsgBox, Please enter a valid key or hit "cancel."
    ; gosub nextkey ; for some reason with this line activated the new gui dialog auto-closes. screw it
  }
}
return

; insert new soundboard key. I'm not repeating all my comments from above, the code is mostly the same.

^!+s::
soundnextkey:
Gui, Add, Text,, `n `n Press the key on your macro keyboard that you want to bind.`n `n
Gui, Add, Text,, Please enter the sound description:
Gui, Add, Edit, vSoundName
Gui, add, button, w200 gsoundnext, Pick Sound, then Add Another
Gui, add, button, Default w200 x+10 gsoundexit, Pick Sound, then Close
Gui, add, button, w70 x+10 gCancel, Cancel
Gui, Show

Return

soundnext:
gosub soundsubmit
sleep 2000
gosub soundnextkey
Return

soundexit:
gosub soundsubmit
sleep 1000
Reload
Return

soundsubmit:
{


  Gui, Submit
  Gui, Destroy


  validkey := StrLen(key)

  if(validkey > 0)
  {

    FileSelectFile, soundpath,,, Select Sound, Audio (*.wav; *.mp2; *.mp3)

    if(soundpath)
    {

      insertscript := "`n `n; /"
      insertscript .= "//" . key . " ============ Begin " . SoundName . " ================ `n"
      insertscript .= "else if (key = """ . key . """) `n"
      insertscript .= "{ `n"
      insertscript .= "  SoundPlay, " . soundpath . " `n"
      insertscript .= "} `n"
      insertscript .= "; ================ End " . SoundName . " ============= " . key . "/// `n `n"

      editingregex := "; //" . "/" . key 
      editingregex .= ".+?" . key . "///"

      FileRead, scriptcontents, OBS-macros.ahk

      updatingscript := RegExMatch(scriptcontents, editingregex)
      if(updatingscript)
      {
        fixedscript := RegExReplace(scriptcontents, editingregex, insertscript,, 1)
      }
      else
      {
        codebelowmarker := "=codebelow" . "marker"
        insertedcode := codebelowmarker . insertscript
        fixedscript := RegExReplace(scriptcontents, codebelowmarker, insertedcode,, 1)
      }

      file := FileOpen("OBS-macros.ahk", "w")
      file.Write(fixedscript)
      file.Close()
    }
  }
  else
  {
    MsgBox, Please enter a valid key or hit "cancel."
    ; gosub soundnextkey
  }
}
return

; ======================= ORIGINAL CREDITS =====================

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; HELLO, poeple who want info about making a second keyboard, using luamacros!

; Here's my LTT video about how I use the 2nd keyboard with Luamacros: https://www.youtube.com/watch?v=Arn8ExQ2Gjg

; And Tom's video, which unfortunately does not have info on how to actually DO it: https://youtu.be/lIFE7h3m40U?t=16m9s

; If you have never used AutoHotKey, you must take this tutorial before proceeding!
; https://autohotkey.com/docs/Tutorial.htm

; So you will need luamacros, of course.
; Luamacros: http://www.hidmacros.eu/forum/viewtopic.php?f=10&t=241#p794
; AutohotKey: https://autohotkey.com/

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~