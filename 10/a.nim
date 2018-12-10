# Solves both parts a and b.
# Both require manually intervention of stepping through the images.
# The constants BEGIN and ITER have beeen found to work after some trial and error.
import nre
import strutils
import strformat

# Point represents a point of the message.
type
    Point = ref object
        x, y: int
        vx, vy: int

# Parses message from the input.
let parsePointRegex = re"position=<(.+)>\svelocity=<(.+)>"
proc parsePoint(line: string): Point =
    let m = line.match(parsePointRegex).get()
    let position = m.captures[0].split(",")
    let velocity = m.captures[1].split(",")

    Point(
        x: parseInt(position[0].strip()),
        y: parseInt(position[1].strip()),
        vx: parseInt(velocity[0].strip()),
        vy: parseInt(velocity[1].strip())
    )

# Get the bounds of the input as well as the points in the input as a sequence of tuples.
proc getBounds(points: seq[Point]): (int, int, int, int, seq[(int,int)]) = 
    var
        maxX = 0
        maxY = 0
        minX = high(int)
        minY = high(int)
        pts = newSeq[(int, int)]()

    for _, p in points:
        if p.x < minX: minX = p.x
        if p.y < minY: minY = p.y
        if p.x > maxX: maxX = p.x
        if p.x > maxY: maxY = p.y

        pts.add((p.x, p.y))

    (minX, minY, maxX, maxY, pts)
    
when isMainModule:
    var
        f: File
        points = newSeq[Point]()
    if open(f, "input.txt"):
        var
            line: string
            ok = true
        while ok:
            try:
                line = readLine(f)
                let p = parsePoint(line)
                points.add(p)
            except EOFError:
                ok = false
            except:
                echo "error reading file"
                raise
    f.close()

    const BEGIN = 10050
    const STEP = 1

    # Seed with EEGIN to get the points closer to each other.
    for i, p in points:
        points[i].x += BEGIN*p.vx
        points[i].y += BEGIN*p.vy
        
        
    var iter = 0
    while true:
        let bounds = getBounds(points)
        # Height should be small for the message to "fit".
        # We avoid printing every permutation using this.
        let height = bounds[3] - bounds[1]
        if height < 200: 
            for y in bounds[1]..bounds[3]:
                for x in bounds[0]..bounds[2]:
                    if (x,y) in bounds[4]:
                        stdout.write("#")
                    else:
                        stdout.write(".")
                echo ""
            echo "----------------------------------------"

        # ENTER to step forward, any other key to break the loop.
        let proceed = readLine(stdin)
        if proceed != "":
            break

        # If we step forward, update points.
        for i, p in points:
            points[i].x +=  STEP*p.vx
            points[i].y +=  STEP*p.vy

        iter += 1
    
    echo &"message is shown after {BEGIN + iter} seconds."