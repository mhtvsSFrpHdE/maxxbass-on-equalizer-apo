# maxxbass-on-equalizer-apo
## What is this
Although you can use Equalizer APO to run some VST plugins like LoudMax, BL Infra,  
due to the unique programming style of waves,  
they will hang the Equalizer APO audiodg service when you try to load them.

## How to use
### Support version
Tested only on `Windows 11 23H2 22631.3880 Windows Feature Experience Pack 1000.22700.1020.0`.

This script only support first x64 build of Waves version `9.6` by default.  
If you need other version, you need to manually open script in code editor and change variables.

Waves 9.6 doesn't provide VST2 interface,  
you need `Blue Cat's PatchWork 2.68` to wrap VST3 on `Equalizer APO 1.3`.

### Dependencies
- Get superUser x64 exe and place into script folder aside `install.ps1`.  
  https://github.com/mspaintmsi/superUser/releases

### Steps
- Install `Blue Cat's PatchWork 2.68` x64 VST version to load VST3 on Equalizer APO.
- Install Waves 9.6, or copy paste Waves `C:\ProgramData\Waves Audio`.
- Install or unzip your `Plug-Ins V9`, `WaveShells V9` to a location can be access by `LOCAL SERVICE`.  
  I find that create a new folder `C:\Program Files\EqualizerAPO\config\VST`  
  and put plugins in to VST folder did the trick.
- Open Equalizer APO, load PatchWork plugin, and load WaveShells 9.6 inside PatchWork.
- Load WaveShells 9.6, not 9.7.
- Choose `Plug-Ins V9` when waves shell ask for it.
- Do rest VST configuration.
- You'll find your system audio is hang, don't worry, run `start_install.bat`.
- Choose `Plug-Ins V9` and OK.
- Script will restart audiodg in the end, waves plugin should work now.



## Troubleshooting (FAQ)
### Preset warning
Save or use preset in a folder that can't be read by `LOCAL SERVICE`  
for either PatchWork or Waves may cause problems.  
Although you can do this in Equalizer APO editor without crash something, because...  
Check "**Behind**" section in README for more information and possible solution.

Put preset under `C:\Program Files\EqualizerAPO\config\VST` should be fine,  
or Equalizer APO save your VST configuration in `config.txt` `ChunkData` section,  
it look like `VSTPlugin: Library "BC PatchWork VST.dll" ChunkData "PD94bWwgyou...`.  
You can have multiple line of PatchWork and use them as alternative of preset.  
If you use preset and cause plugins bugged, remove lines in Equalize APO `config.txt`,  
reboot, `start_install.bat`, add blank PatchWork (do not paste with ChunkData), redo VST configuration.

### PatchWork crashed even if not load any VST3
You may use a mismatch PatchWork version,  
suggest `PatchWork 2.68` and for `Equalizer APO 1.3`

### Wave shell 9.6 is not a valid VST3...
LOL, install latest `vc_redist` 2012 x86 or x64 from Microsoft.

### When first time load wave shell in PatchWork, it ask Plug-Ins V9 folder again and again
- Remove PatchWork from Equalizer APO editor.
- End `audiodg.exe` process, it will restart anyway, just ensure wave shell is not running.
- Go to `%AppData%`, delete `Waves Audio` folder or if you want a precise, carefully operation,  
  delete `V9PluginFolder_ScanView.txt`.
- Add PatchWork and add Wave shell to check if this time you get pass.
- If still, open `%AppData%\Waves Audio\Preferences\V9PluginFolder_ScanView.txt`, edit path manually.
- If still, check if that folder contains valid waves plugins.  
  You may also need all the `WavesLib_9.6...` dll out there.

### I didn't see MaxxBass or my plugin in Wave shell
Check you're loading `WaveShell-VST3 9.6_x64.vst3`,  
instead of version `9.7`.

### Switch between `Audio`, `MaxxBass`, `Original Bass` not work
Open PatchWork panel, Check `Apply automatically`.

### Uninstall
Run `start_uninstall.bat` to delete created waves folder in local service folder.

### I moved `Plug-Ins V9` folder
Waves will save plugin search location to  
`%AppData%\Waves Audio\Preferences\V9PluginFolder_ScanView.txt`,  
delete this file if you moved `Plug-Ins V9` folder to trigger folder open dialog in Equalizer APO.  
After VST configuration, run `start_install.bat` again.

### Debug shell
- Get psexec, if you want to use test script.  
  https://learn.microsoft.com/en-us/sysinternals/downloads/psexec
- Open `start_test.bat`, you have a cmd window with `LOCAL SERVICE` permission,  
  run `test_notepad.bat` to open installed config file with `notepad.exe` to view content.

### Waves 9.6?
MaxxBass didn't change since 1998.  
Unless you do love to have Waves 2024 electron (EdgeWebView2) frontend for nothing.

## Behind
Equalizer APO audio service process run as `LOCAL SERVICE`,  
but the `config.exe` editor itself run as normal user while doing VST configuration.  
During the VST configuration, VST plugins also run as normal user.  
However, `LOCAL SERVICE` doesn't have permissions to access normal user files  
even a service sounds like have higher permission.  
In this case, only use `ChunkData` to communicate with audio service,  
don't let them to access file if unnecessary.

Waves plugins is exception, Wave shell use dialog to ask `Plug-Ins V9` location  
if it didn't found saved path in `%AppData%` which redirected to  
`C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\Waves Audio\Preferences\V9PluginFolder_ScanView.txt`  
for `LOCAL SERVICE` account instead of normal user's `%AppData%`.  
The dialog will block execution of the process so your audio service hangs.

This handy script help you to choose your `Plug-Ins V9`  
and generate a config file under `LocalService\AppData` to prevent the dialog.
