import strutils
import strformat
import algorithm

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

# Get the closest point to the given point `px` from the sequence `points`.
# This returns the index at which min is found.
# Also, if two or more points contest for the min, an index `-1` is returned meaning drop the point
# from the logic.
proc closestPoint(points: seq[Point], px: Point): int =
    var minDistance = getManhattanDistance(px, points[0])
    var minPointIdx = 0

    # Keep track of all seen distances to find min collisions later on.
    var distances = newSeq[int]()
    distances.add(minDistance)
    for i in countup(1, points.len()-1):
        let distance = getManhattanDistance(px, points[i])
        distances.add(distance)
        if distance < minDistance:
            minDistance = distance 
            minPointIdx = i

    # Weed out collisions.
    var matchDistances = 0
    for _ ,d in distances:
        if minDistance == d:
            matchDistances += 1
        
        if matchDistances > 1:
            return -1

    minPointIdx

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

    # Iterate over the visible grid finding points that are closest.
    # Keep updating the area and also check if the points are on the edges.
    # If the points belong to an area and are on the edge, then mark the area as Infinite.
    for x in countup(0, maxGridX):
        for y in countup(0, maxGridY):
            let c = closestPoint(pointList, (x,y, false, 0)) + 1
            if c > 0: 
                pointList[c-1].area += 1
                if x == 0 or x == maxGridX or y == 0 or y == maxGridY:
                    pointList[c-1].isInfinite = true
    

    # For all finite area regions, find the one with the max area.
    var maxFiniteArea = 0
    var maxFiniteAreaPoint: Point
    for _ , p in pointList:
        if not p.isInFinite:
            if p.area > maxFiniteArea:
                maxFiniteArea = p.area
                maxFiniteAreaPoint = p
    
    echo &"max finite region area is {maxFiniteAreaPoint.area}"
