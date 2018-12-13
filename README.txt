i3 config

Status Display :
Free Mem | IP | Network Use | CPU | RAM | sink# vol% | Week# Date Time

Volume :
- (if the system has more than one sink card installed)
  check index for audio card : pactl list sinks short
  set variable "SINK" in bin/pacvol.sh
- more than 100% volume can be set in bin/pacvol.sh (i.e. LIMITVOL=0)

Requirements :
conky  
pulseaudio (pactl, pacmd)   

- tested on ubuntu 18.04

 
