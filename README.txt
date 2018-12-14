i3 config

Status Display :
Free Mem | IP | Network Use | CPU | RAM | sink# vol% | Week# Date Time

Requirements :
conky  
pulseaudio (pactl, pacmd)   

Some shortcuts :
- All Default i3 shortcuts
- APPS :
	Super + b : Browser
	Super + Enter : Terminal
	Super + Shft + Enter : File manager
	
- Volume :
	Up/Down/Mute : Dedicated Keys
	Up/Down/Toggle : Super + '+' '-' '/' (on Keypad)
	Up beyond 100% : Super + Shift + '+' or 'VolumeUp'

- Exit :
	Exit mode : Super + End
	quick Lock (Black screen) : Super + l 

- Workspace :
	Super + Ctrl + ArrowKey : switch to a workspace on right/left
	Super + Shift + Number : Shift container to another workspace
	Super + Shift +  Ctrl + Number : Shift container and switch to another workspace


Other notes :
- Default Mod is SuperKey (Mod4)
- floating is enabled for pop-up / dialog box etc
- to shift focus 'l' is replaced with 'o' in favor of lock
- tested on ubuntu 18.04 with gnome-desktop
-

# Volume :
- (if the system has more than one sink card installed)
  check index for audio card : pactl list sinks short
  set variable "SINK" in bin/pacvol.sh
- more than 100% volume can be set in bin/pacvol.sh (i.e. LIMITVOL=0)

# File Manager :
- Chnage default file manager (Super+Shift+Enter) to dolphin or nautilus using, 
  xdg-mime default org.kde.dolphin.desktop inode/directory
  xdg-mime default nautilus.desktop inode/directory


# Troubleshoot :
-- GUI fail to launch for OpenCV3 gui
   Doplhin icons missing
-> https://askubuntu.com/questions/747064/icon-missing-dolphin  


# Issues :
-- 



