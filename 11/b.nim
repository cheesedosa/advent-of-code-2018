import strformat

# get score for each point.
proc getScore(point:(int, int), gridNum: int): int =
    let rackID = point[0] + 10
    let begin = rackID * point[1]
    let increase = begin + gridNum
    let powerLevel = increase * rackID
    let hundredthDigit = int(powerLevel/100).mod(10)
    
    hundredthDigit-5
    
    
when isMainModule:
    const
        GRIDNUM = 8979
        BOUNDX = 300
        BOUNDY = 300
    var
        maxScore = 0
        cellID: (int,int)
        maxScale = 0
        grid: array[BOUNDX+1,array[BOUNDY+1, int]]

    # Partial sums
    for y in countup(1, BOUNDY):
        for x in countup(1, BOUNDX):      
            grid[x][y] = getScore((x,y), GRIDNUM) + grid[x-1][y] + grid[x][y-1] - grid[x-1][y-1]


    # Try for each scale.
    for scale in countup(1, BOUNDX):
        for y in countup(scale, BOUNDY):
            for x in countup(scale, BOUNDX):
                let score = grid[x][y] + grid[x-scale][y-scale] - grid[x-scale][y] - grid[x][y-scale] 
                if score > maxScore:
                    maxScore = score
                    cellID = (x - scale + 1,y - scale + 1)
                    maxScale = scale
            

    echo &"max score is: {maxScore} for cell: {cellID} and scale: {maxScale}"