import nre
import strutils
import strformat

# Define claim and parse from a string.
type
    Claim = tuple[id, x,y,width,height: int]

let claimRegex = re"#([0-9]+)\s@\s([0-9]+),([0-9]+):\s([0-9]+)x([0-9]+)"
proc parseClaim(claim: string): Claim =
    let cl = claim.match(claimRegex).get()
    (id: parseInt(cl.captures[0]),x:parseInt(cl.captures[1]),y:parseInt(cl.captures[2]),width:parseInt(cl.captures[3]),height:parseInt(cl.captures[4]))

when isMainModule:
    const 
        MAXWIDTH = 1000
    var
        f: File
        fabricGrid = newSeq[int](1000*1000)
        claims = newSeq[Claim]()
    if open(f, "input.txt"):
        var 
            line: string
            ok = true
        
        # Read in claims and set a count for overlapping claims in fabric.
        while ok:
            try:
                line = readLine(f)
                let cl= parseClaim(line)
                claims.add(cl)
                for i in countup(cl.x+1, cl.x + cl.width):
                    for j in countup(cl.y+1, cl.y + cl.height):
                        fabricGrid[i*MAXWIDTH+j] += 1
            except EOFError:
                ok = false
            except:
                echo "error reading claims from file"
                raise

    # Find the claim that doesn't overlap.
    for _, cl in claims:
        var clArea = 0
        for i in countup(cl.x+1, cl.x + cl.width):
            for j in countup(cl.y+1, cl.y + cl.height):
                if fabricGrid[i*MAXWIDTH+j] == 1:
                    clArea += 1
        
        if clArea == cl.width * cl.height:
            echo &"claim {cl.id} does not overlap"
            break
    