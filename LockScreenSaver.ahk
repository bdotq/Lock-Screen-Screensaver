; Simple (Non-)Screensaver framework (can be used to create own Screensavers by compiling and renaming to .scr).  This script requires v1.0.44.12 or later
; This script consists of :
; many code-snippets from the AHK-Help File and of certain lines from this forum ;-)
; it was inspired by the input from this Forum, the Scrrensaver tutorial at http://www.wischik.com/scr/howtoscr.html and the MSDN help pages
; so it´s mostly not my code
;--------------------------------------------------------------------------------------------------------------------------------------
#NoTrayIcon
#SingleInstance force
;CoordMode, Mouse, Screen
applicationname=LockScreenSaver
ran = 0
;--------------------------------------------------------------------------------------------------------------------------------------
;this is the main section, which will run on startup
;as the behaviour expected of the saver depends on the command-line arguments it is given
;first the command-line arguments are checked using the 
;build in vars 0,1,2,3,... ,where 0 contains the number of command-line arguments given
;there are several rules for reacting to command-line arguments
;if the command line arguments are invalid, then the saver should terminate immediately without doing anything.
;if argument = /c, /c ####, or no arguments at all - in response to any of these the saver should pop up its configuration dialog. 
;if argument = /s - this indicates that the saver should run itself as a full-screen saver.
;if argument = /p ####, or /l #### - here the saver should treat the #### as the decimal representation of an HWND, and  pop up a child window to run in preview mode inside that window.
;if argument = /a #### - this argument is only used in '95 and Plus! The saver should pop up a password-configuration dialog.
;the command-line options may appear as lower-case or upper-case, and that there might be either a forward slash or a hyphen prefixing the letter.
; this script does not support all the modes
; it will show no preview window and no pw-change window under W9x and
; the config window has probably not the right owner
;--------------------------------------------------------------------------------------------------------------------------------------
if 0 = 0 ; checks if no command-line arguments have been passed
{
runmode = config ; the var runmode is used to decide what action the screensaver shall perform 
}
else
{
   Loop, %0%  ; For each parameter:
   {
      param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
      if param contains s,S
      {
         runmode = show
         break
      } 
      if param contains c,C
      {
         runmode = config
         break
      }
      if param contains p,P,l,L
      {
         runmode = preview
         break
      }
      if param contains a,A
      {
         runmode = pwconfig
         break
      }
      else
      {
         runmode = undefined
      }
   }
}
; load the configuration via the getconf subroutine
;GoSub, getconf
; decide what mode to start
; right now only show and config are supported, all other modes will exit the saver
if runmode = show
{
GoSub, svrshow
}
if runmode = config
{
GoSub, svrconfig
}
if runmode = preview
{
GoSub, svrend
}
if runmode = pwconfig
{
GoSub, svrend
}
if runmode = undefined
{
GoSub, svrend
}
return

;--------------------------------------------------------------------------------------------------------------------------------------
 ; the getconfig subroutine should contain all the internal and external configuration
; it is called by the startup section prior to all other subroutines
;--------------------------------------------------------------------------------------------------------------------------------------
getconf:
;MouseGetPos, MousePosX, MousePosY ; stores original coursor-position to put it back there before stopping the saver
;here the saver configuration is read from the registry and set to default values if no configuration data is present in the registry
; make shure to chose your own values for CompanyName and Product Name
;RegRead, runCmd, HKEY_CURRENT_USER, Software\BQSoft\RunCommandSaver\, Command
;if not runCmd
;{ 
;runCmd = cmd.exe  ; command to run default cmd
;}
;RegRead, Mouseoffset, HKEY_CURRENT_USER, Software\AHKSaver\MyAHKSaver\, MOffset
;if not Mouseoffset
;{ 
;Mouseoffset = 3  ; Can be any full number
;}

return
;--------------------------------------------------------------------------------------------------------------------------------------
; svrconfig shows the configuration dialog of the saver 
;the ButtonOK subroutine stores the changes if OK is pressed
; this mode is not fully implemented, as it SHOULD really:
; With /c  as an argument, use the ForegroundWindow as its parent. 
;With /c ####  the saver should treat #### as the decimal representation of an HWND, and use this as its parent.
;If there are no arguments then NULL should be used as the parent.
;BUT it DOES show only a very general configuration dialog without regarding any of these options
;--------------------------------------------------------------------------------------------------------------------------------------
svrconfig: 
Gui,Destroy
;Gui, Add, GroupBox, w380 xm+10 y+10, &Run Command
;Gui, Add, Text, xm+10 yp+10, Command to run when screensaver is activated:
;Gui, Add, Edit, vconfig1 w50 xm+10 yp+20 w380, %runCmd%
;Gui,Add,Button,x+5 yp vvbrowse GBROWSE w70,Browse
;Gui, Add, Text,, Minimum movement the Mouse has to make to quit the saver (in pixel) :
;Gui, Add, Edit, vconfig2, %Mouseoffset%
;Gui, Add, Button, xm+10 y+23 ButtonOK default, &OK  ; The label ButtonOK  will be run when the button is pressed.
;Gui, Add,Button,xm+10 y+10 GSETTINGSOK Default w75,&OK
;Gui, Add,Button, x+5 yp GSETTINGSCANCEL,&Cancel

Gui,Font,Bold
Gui,Add,Text,xm+10 y+10,Lock Screen Saver v1.0.
Gui,Font
Gui,Add,Text,xm+10 y+0,A screensaver that when activated locks the screen to the Welcome Screen 
Gui,Add,Text,xm+10 y+0,or the user login (similar to WIN + L). For Windows XP.
Gui,Font
Gui,Add,Text,xm+10 y+10,Created by Brian Quan 2007.
Gui,Font,CBlue Underline
Gui,Add,Text,xm+10 y+0 gBQdotcom,www.brianquan.com
Gui,Font,norm
;Gui,Add,Text,y+0,`t
Gui, Add,Button, xm+10 y+23 GSETTINGSCANCEL,&OK

Gui, Show, w500, Lock Screen Saver Settings
;for mouse cursor to change to hand when over URL
hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 
return

;--------------------------------------------------------------------------------------------------------------------------------------
; the ButtonOK label is run when the OK Button from scrconfig is pressed
; it stores the configuration in the registry
;.It should be saved in the registry in the standard location: HKEY_CURRENT_USER\Software\MyCompany\MyProduct\.
;--------------------------------------------------------------------------------------------------------------------------------------

;ButtonOK: 
;Gui, Submit
; make shure to chose your own values for CompanyName and Product Name
;RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\BQSoft\RunCommandSaver\, Command, %config1%
;RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\AHKSaver\MyAHKSaver\, MOffset, %config2%
;Gosub, svrend
;return

;BROWSE:
;FileSelectFile,file
;GuiControl,,config1,%file%
;return

SETTINGSCANCEL:
Gui,Destroy
Gosub, svrend
return

BQdotcom:
Run,http://www.brianquan.com,,UseErrorLevel
return

;for the cursor to change to hand when hover URL
WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,winid,ctrl
  If ctrl in Static5 ;text static object, 5th down on GUI
    DllCall("SetCursor","UInt",hCurs)
}

;--------------------------------------------------------------------------------------------------------------------------------------
;this is the actual screensaver
;the svrshow subroutine will display the fullscreen saver
;therefore it should end with an endless Loop
;the saver terminates itself by incoming Windows Messages, so
;there is no need to continuously check the mouse positon or any keystrokes 
;--------------------------------------------------------------------------------------------------------------------------------------
svrshow:

; this block creates a fullscreen window without any borders in any color set in the var ;"CustomColor"
;Gui, +AlwaysOnTop +LastFound +Owner  ; +Owner prevents a taskbar button from appearing.
;Gui, Color, %CustomColor%
;Gui, -Caption  ; Remove the title bar and window borders.
;Gui, Show, x0 y0 Maximize
;DllCall("SetCursorPos", int, A_ScreenWidth, int, A_ScreenHight) ; sets the mouse to a position ;outside the visible sreen and thus making the cursor unvisible
;sleep, 100
; this block checks the actual mouse position and creates defines the parking position of the mouse
;MouseGetPos, MouseX, MouseY
;LowerLimitY := (MouseY - Mouseoffset)
;UpperLimitY := (MouseY + Mouseoffset)
;LowerLimitX := (MouseX - Mouseoffset)
;UpperLimitX := (MouseX + Mouseoffset)
;sleep, 1000

; the following OnMessage commands make the Screensaver listen to several Window Messages
; to get information if the mouse was moved, a mouse-button pressed or a system key or non-system key on the keybord was pressed
; whenever the system sends one of the messages below , the script will start the WM_ENDAPP() funktion
; this will eventually exit the saver
;OnMessage(0x201, "WM_ENDAPP") ; WM_LBUTTONDOWN : indicates that the left mouse button was pressed
;OnMessage(0x204, "WM_ENDAPP") ; WM_RBUTTONDOWN : indicates that the right mouse button was pressed
;OnMessage(0x207, "WM_ENDAPP") ; WM_MBUTTONDOWN : indicates that the middle mouse button was pressed
;OnMessage(0x200, "WM_ENDAPP") ; WM_MOUSEMOVE : indicates that the mouse was moved
;OnMessage(0x100, "WM_ENDAPP") ; WM_KEYDOWN : indicates that a non-system key was pressed
;OnMessage(0x104, "WM_ENDAPP") ; WM_SYSKEYDOWN : indicates that a system key was pressed
;OnMessage(0x1C, "WM_ENDAPP") ; WM_ACTIVATEAPP : indicates that another application needs the focus 
;OnMessage(0x06, "WM_ENDAPP") ; WM_ACTIVATE : indicates that another application needs the focus
;OnMessage(0x10, "WM_ENDAPP") ; WM_CLOSE : indicates that the system wants to close the program
;the next line should block Ctrl+Alt+Esc and Alt+Tab under Win9x, but it´s not tested and only neccesary for pw-protection under Win9x
;DllCall("SystemParametersInfo", "Str", "SPI_SETSCREENSAVERRUNNING", "UInt", "1", "UInt*", previousstate, "UInt", "0")

Loop
{

if ran = 1
{
Gosub, svrend
}
if ran = 0
{
ran = 1
Run,C:\WINDOWS\system32\rundll32.exe user32.dll`, LockWorkStation,,UseErrorLevel
if ErrorLevel = ERROR
    MsgBox Unable to execute the application.
sleep, 3000
}

}
return
;--------------------------------------------------------------------------------------------------------------------------------------
; WM_ENDAPP is the handler for the incoming Windows Messages
; it will call the svrend subroutine to end the screensaver if any of the Messages above will arrive
;--------------------------------------------------------------------------------------------------------------------------------------
WM_ENDAPP()
{
Gosub, svrend
return
}
;--------------------------------------------------------------------------------------------------------------------------------------
; CHECKENDAPP is the handler for the incoming Windows Message WM_MOUSEMOVE
; it will call the svrend subroutine to end the screensaver if the Mouse has left the parking position
;--------------------------------------------------------------------------------------------------------------------------------------
;WM_CHECKEND()
;{
;MouseGetPos, MouseX, MouseY
; first make the global parking position var accessible in this funktion
;global LowerLimitX
;global LowerLimitY
;global UpperLimitX
;global UpperLimitY
; then check if mouse has left the parking position
;if MouseX not between %LowerLimitX% and %UpperLimitX% 
;GoSub, svrend
;if MouseY not between %LowerLimitY% and %UpperLimitY%
;GoSub, svrend
;return
;}
;--------------------------------------------------------------------------------------------------------------------------------------
;This is the programm closing subroutine, all other subroutines or funtions will call this to exit the saver
; GuiClose and svrend will both execute the following
;--------------------------------------------------------------------------------------------------------------------------------------
GuiClose: ;  in case the config gui was aborted
GoSub, svrend
return

svrend:
;the next line should unblock Ctrl+Alt+Esc and Alt+Tab under Win9x, but it´s not tested and only neccesary with the corresponding DllCall-Line above
;DllCall("SystemParametersInfo", "Str", "SPI_SETSCREENSAVERRUNNING", "UInt", "0", "UInt*", previousstate, "UInt", "0")
Gui, Destroy
;DllCall("SetCursorPos", int, MousePosX, int, MousePosY) ; moves the Cursor back to where it was before screensaver started
ExitApp
;--------------------------------------------------------------------------------------------------------------------------------------
