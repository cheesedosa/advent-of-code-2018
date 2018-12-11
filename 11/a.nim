import strformat

# gets score for each point.
proc getScore(point: (int, int), gridNum: int, bounds: (int, int)): (int, bool) =
    if point[0] + 2 > bounds[0] or point[1] + 2 > bounds[1]:
        return (-1, true)
    
    var score = 0
    for y in countup(point[1], point[1]+2):
        for x in countup(point[0], point[0]+2):
            let rackID = x + 10
            let begin = rackID * y
            let increase = begin + gridNum
            let powerLevel = increase * rackID
            let hundredthDigit = int(powerLevel/100).mod(10)
            score = score + (hundredthDigit-5)

    (score, false)
    
    
when isMainModule:
    const
        GRIDNUM = 8979
        BOUNDX = 300
        BOUNDY = 300
    var
        maxScore = 0
        cellID: (int,int)
    for x in countup(1, BOUNDX):
        for y in countup(1, BOUNDY):
            let result = getScore((x,y), GRIDNUM, (BOUNDX,BOUNDY))
            if not result[1]:    
                if result[0] > maxScore:
                    maxScore = result[0]
                    cellID = (x,y)

    echo &"max score is: {maxScore} for cell: {cellID}"