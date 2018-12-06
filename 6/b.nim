import strutils
import strformat

# Point represents a point co-ordnates for the input.
type
    Point = tuple[
        x: int,
        y: int,
        isInFinite: bool,
        area: int
    ]

# Parse a Point from the string.
proc parsePoint(str: string): Point =
    let s = str.split(',')
    (x: parseInt(s[0].strip()), y: parseInt(s[1].strip()), isInFinite: false, area: 0)

# Get the Manhattan distance between two points.
proc getManhattanDistance(p1, p2: Point): int =
    return abs(p1.x - p2.x) + abs(p1.y - p2.y)

when isMainModule:
    var
        f: File
        pointList = newSeq[Point]()
        maxGridX: int
        maxGridY: int
    if open(f, "input.txt"):
        var
            line: string
            ok = true
        while ok:
            try:
                line = readLine(f)
                let p = parsePoint(line)
                if p.x > maxGridX:
                    maxGridX = p.x
                if p.y > maxGridY:
                    maxGridY = p.y
                pointList.add(p)
            except EOFError:
                ok = false
            except:
                echo "error reading points from file"
                raise
    f.close()

    # Pretty straight forward,
    # for each point on the visible grid find the distances from each points
    # and aggregate the area.
    var area = 0
    for x in countup(0, maxGridX):
        for y in countup(0, maxGridY):
            let pg = (x,y,false,0)
            var distanceSum = 0
            for _, p in pointList:
                distanceSum += getManhattanDistance(p,pg)

            if distanceSum < 10000:
                area += 1

    echo &"area of the region is {area}"