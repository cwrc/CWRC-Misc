# 2014-02-12
# powershell script to "format and indent" all files in a specified directory
# via Oxygen in a batch mode by sending key sequences.

# setup
# powershell
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted
# Get-ExecutionPolicy
# run command

# preprocess
# 2014-02-24
# 'join and normalize' adds an extra space between elements that were 
# separated by a 'newline'
# Within Oxygen, 'find==>'find/replace in Files'
# test to find: \n\s* within //P
#
# fix replace with: 'nothing'
# set specified path to list of files.

    
# requirements in the Oxygen Setting:
# Oxygen startup window - disable
# associate file type with editor to prevent popup asking if '.sgm' is xml.
# add command to switch to text mode options->preferences "Menu Shortcut Keys" "Text" ctrl+Shift+Alt+<F12> 

# reference:
# http://stackoverflow.com/questions/19824799/how-to-send-ctrl-or-alt-any-other-key

# Post process
#FILES=./data/*
#for f in $FILES
#do
#        echo "Processing $f file..."
#        # remove the processing instructions after the batch change
#        # and Oxygen XML join which mushes them onto one line
#        perl  -pi -e 's#<\?xml.*\]>\n##' $f
#done
# 

# NOTE: 2014-10-05 - had trouble running in Oxygen 16.0 switched back to 15.2

[void][reflection.assembly]::loadwithpartialname("system.windows.forms")

#$in = "C:\Users\jefferya.ARTSRN\Downloads\oxygen_batch_2014-02-12\"
$in = "C:\Users\jefferya.ARTSRN\Downloads\o2_preferences"
#$oxygen_exe = "C:\Program Files\Oxygen XML Editor 16\oxygenAuthor16.0.exe"
$oxygen_exe = "C:\Program Files\Oxygen XML Editor 15\oxygenAuthor15.2.exe"

Write-Host
Write-Host 'Begin Batch Process'

# open an instance of Oxygen XML and wait until finished opening 
Write-Host "Wait...:"
& "$oxygen_exe" 
Start-Sleep -s 5 

$fileList = Get-ChildItem $in

for ($i=0; $i -lt $fileList.Count; $i++)
{
    $count = $fileList.Count
    $filename = $fileList[$i]

    # open an tab in Oxygen XML and wait until finished opening 
    Write-Host
    Write-Host "opening "($i+1)" of $count : "$fileList[$i].FullName
    Write-Host
    Write-Host $oxygen_exe $fileList[$i].FullName
    Write-Host
    & "$oxygen_exe" $fileList[$i].FullName
    
    Write-Host "Wait...:"
    Start-Sleep -s 5 

    Write-Host "Switch to text mode ctrl+alt+shift+<f12>"
    [System.Windows.Forms.SendKeys]::SendWait("^+%{F12}") 
    Start-Sleep -s 2 

    #Write-Host "Oxygen select all ctrl+a"
    #[System.Windows.Forms.SendKeys]::SendWait("^{a}") 
    #Start-Sleep -s 2 

    # 2014-02-24
    # adds an extra space between elements that were 
    # separated by a 'newline'
    #Write-Host "Oxygen join ctrl+j"
    #[System.Windows.Forms.SendKeys]::SendWait("^{j}") 
    #Start-Sleep -s 2 

    Write-Host "Oxygen Format and Indent ctrl+shift+p"
    [System.Windows.Forms.SendKeys]::SendWait("^+{p}") 
    Start-Sleep -s 4 

    Write-Host "Oxygen save ctrl+s"
    [System.Windows.Forms.SendKeys]::SendWait("^{s}") 
    Start-Sleep -s 4 
    Write-Host "Saved: $filename"

    Write-Host "Oxygen file close ctrl+w"
    [System.Windows.Forms.SendKeys]::SendWait("^{w}") 
    #Start-Sleep -s 2 

    # don't need ot close Oxygen each time
    #Write-Host "Oxygen close ctrl+q"
    #[System.Windows.Forms.SendKeys]::SendWait("^{q}") 
    #Start-Sleep -s 2 

}

#end of script
