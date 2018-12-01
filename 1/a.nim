from strutils import parseInt
import strformat

when isMainModule:
    var f: File
    if open(f, "input.txt"):
        var line: string
        var freq = 0
        var ok = true
    
        while ok:
            try:
                line = readLine(f)
                freq += parseInt(line)
            except EOFError:
                ok = false
            except:
                echo "error reading changes from file"
                raise
            
        close(f)
        echo &"frequency is: {freq}"
