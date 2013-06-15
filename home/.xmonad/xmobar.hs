
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

Config {
  font = "xft:Fixed-8",
       bgColor = "#000000",
       fgColor = "#ffffff",
       position = Static { xpos = 0, ypos = 0, width = 1200, height = 16 },
       lowerOnStart = True,
       commands = [
         Run Battery [
         "-t", "<acstatus>: <left>%",
       "--",
       "-c", "charge_full",
       "-O", "AC",
       "-o", "Bat",
       "-h", "green",
       "-l", "red"
         ] 10,
       Run Weather "EDDB" ["-t","<tempC>°C <skyCondition>","-L","64","-H","77","-n","#CEFFAC","-h","#FFB6B0","-l","#96CBFE"] 36000,
       Run MultiCpu ["-t","Cpu: <total0> <total1> <total2> <total3>","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10,
       Run TopProc [] 50,
       Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
       Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
       Run Network "wlan0" ["-t","Net: <rx>, <tx>","-H","200","-L","10","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
       Run Date "%a %b %_d %l:%M" "date" 10,
       Run StdinReader
         ],
       sepChar = "%",
       alignSep = "}{",
       template = "%StdinReader% }{TopProc: %top%    %battery%   %multicpu%   %memory%   %swap%   %wlan0%   <fc=#FFFFCC>%date%</fc>   %EDDB%"
}
