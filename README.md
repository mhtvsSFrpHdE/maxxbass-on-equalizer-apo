# Why

Although you can use Equalizer APO to run some VST plugins like LoudMax, BL Infra,  
due to the delicated programming style of waves,  
they will hang the Equalizer APO audiodg service when you try to load them.

# How to use

This script support oldest x64 build of Waves version `9.6`.  
If you need other version, you need to manually open script in editor and change variables.

- Get https://github.com/mspaintmsi/superUser x64 exe and place into script folder.
- Get https://learn.microsoft.com/en-us/sysinternals/downloads/psexec same as above, if you want to use test related script.
- Install `Blue Cat's PatchWork 2.68` x64 and VST version to load VST3 on Equalizer APO version `1.3`.
- Install Waves 9.6, or copy paste Waves `C:\ProgramData\Waves Audio`.
- Install or unzip your `Plug-Ins V9`, `WaveShells V9`.
- Open Equalizer APO, load PathWork plugin, and load WaveShells 9.6 inside PathWork.
- Load WaveShells 9.6, not 9.7.
- Choose `Plug-Ins V9` when waves shell ask for it.
- Do rest VST configuration.
- You'll find your system audio is hang, don't worry, run `start_install.bat`.
- Choose `Plug-Ins V9` and OK.
- Script will restart audiodg in the end, waves plugin should work now.

# Warning
- Don't use preset feature either for PathWork or Waves, they can cause hang for unknown reason.
- Equalizer APO will save your configuration in `config.txt`, you can have multiple line of PathWork and use them as profile alternative
- If you use preset and cause plugins bugged, remove lines in Equalize APO `config.txt`, reboot, `start_install.bat`, add Pathwork and continue from there.

# Uninstall
- Run `start_uninstall.bat` to delete created waves folder in local service folder.
