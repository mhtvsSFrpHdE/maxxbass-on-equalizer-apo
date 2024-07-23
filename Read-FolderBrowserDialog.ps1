# https://www.reddit.com/r/PowerShell/comments/9s0q6k/folder_browser_dialog_with_an_address_bar/

function Read-FolderBrowserDialog($DialogTitle="Select folder", $DialogInitialDirectory="") {
    $AssemblyFullName = 'System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
    $Assembly = [System.Reflection.Assembly]::Load($AssemblyFullName)
    $OpenFileDialog = [System.Windows.Forms.OpenFileDialog]::new()
    $OpenFileDialog.AddExtension = $false
    $OpenFileDialog.CheckFileExists = $false
    $OpenFileDialog.DereferenceLinks = $true
    $OpenFileDialog.Filter = "Folders|`n"
    $OpenFileDialog.Multiselect = $false
    $OpenFileDialog.Title = $DialogTitle
    $OpenFileDialog.InitialDirectory = $DialogInitialDirectory
    $OpenFileDialogType = $OpenFileDialog.GetType()
    $FileDialogInterfaceType = $Assembly.GetType('System.Windows.Forms.FileDialogNative+IFileDialog')
    $IFileDialog = $OpenFileDialogType.GetMethod('CreateVistaDialog',@('NonPublic','Public','Static','Instance')).Invoke($OpenFileDialog,$null)
    $OpenFileDialogType.GetMethod('OnBeforeVistaDialog',@('NonPublic','Public','Static','Instance')).Invoke($OpenFileDialog,$IFileDialog)
    [uint32]$PickFoldersOption = $Assembly.GetType('System.Windows.Forms.FileDialogNative+FOS').GetField('FOS_PICKFOLDERS').GetValue($null)
    $FolderOptions = $OpenFileDialogType.GetMethod('get_Options',@('NonPublic','Public','Static','Instance')).Invoke($OpenFileDialog,$null) -bor $PickFoldersOption
    $FileDialogInterfaceType.GetMethod('SetOptions',@('NonPublic','Public','Static','Instance')).Invoke($IFileDialog,$FolderOptions)
    $VistaDialogEvent = [System.Activator]::CreateInstance($AssemblyFullName,'System.Windows.Forms.FileDialog+VistaDialogEvents',$false,0,$null,$OpenFileDialog,$null,$null).Unwrap()
    [uint32]$AdviceCookie = 0
    $AdvisoryParameters = @($VistaDialogEvent,$AdviceCookie)
    $AdviseResult = $FileDialogInterfaceType.GetMethod('Advise',@('NonPublic','Public','Static','Instance')).Invoke($IFileDialog,$AdvisoryParameters)
    $AdviceCookie = $AdvisoryParameters[1]
    $Result = $FileDialogInterfaceType.GetMethod('Show',@('NonPublic','Public','Static','Instance')).Invoke($IFileDialog,[System.IntPtr]::Zero)
    $FileDialogInterfaceType.GetMethod('Unadvise',@('NonPublic','Public','Static','Instance')).Invoke($IFileDialog,$AdviceCookie)

    $folderResultObject = New-Object PsObject -Property @{success=$false ; result=""}
    if ($Result -eq 0) {
        $folderResultObject.success = $true
        $folderResultObject.result = $OpenFileDialog.FileName
        return $folderResultObject
    }

    return $folderResultObject
}
