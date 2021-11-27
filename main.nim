import std/[os, sequtils, strutils]

proc console_pause() = 
    echo "Press any key..."
    var input = readline(stdin)

when not defined(windows):
    echo "System is not windows"
    console_pause()
    quit(QuitFailure)
    
var AssetsFolder = getHomeDir() & "AppData\\Local\\Packages\\"
let packages = toSeq(walkDir(AssetsFolder, relative=true))
                            .mapIt(it.path)
                            .filterIt(it.contains("Microsoft.Windows.ContentDeliveryManager"))
if packages.len == 0:
    echo "Microsoft.Windows.ContentDeliveryManager package not found"
    console_pause()
    quit(QuitFailure)

AssetsFolder &= packages[0] & "\\LocalState\\Assets\\"
echo AssetsFolder
const min_picture_size = 500 * 1024
let pictures = toSeq(walkDir(AssetsFolder, relative=true)).filterIt(getFileSize(AssetsFolder & it.path) > min_picture_size)
for file in pictures:
    try:
        copyFileToDir(AssetsFolder & file.path, getCurrentDir())
    except ValueError as e:
        echo "Can't copy " & file.path & "file: " & e.msg
        continue
    moveFile(file.path, addFileExt(file.path, "jpg"))
    echo file.path & "completed"

console_pause()
