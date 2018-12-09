import sequtils
import strformat

# Terrible solution using slicing of sequences.
# Slicing and appending to the sequence for each insert is VERY costly.
# This is specially noticeable in the part B where the number of
# iteration is very high.
# A better solution is by using a linked list or mutate the circle.
# or from https://www.reddit.com/r/adventofcode/comments/a4i97s/2018_day_9_solutions/
# use a deque to maintain the circle state which is VERY elegant.
# Unfortunately I couldn't think of it and spent a lot of time 
# implementing the solution using arrays.
when isMainModule:
    const numPlayers = 493
    const lastMarble = 71863

    var circle = newSeq[int]()
    var currentMarbleIdx = 1
    var scores : array[numPlayers, int]
    var scoreRound = 0
    circle.add(0)
    circle.add(1) 
    for i in countup(2, lastMarble):
        var marbleIdx = currentMarbleIdx + 2
        if marbleIdx > circle.len():
            marbleIDx = 1
        if i.mod(23) == 0:
            var seventhFromCurrentIdx = currentMarbleIdx-7
            if seventhFromCurrentIdx < 0:
                seventhFromCurrentIdx = circle.len() + seventhFromCurrentIdx
                
            let playerIdx = (i-1).mod(numPlayers)
            scores[playerIdx] +=  i + circle[seventhFromCurrentIdx]
            circle = circle[0..seventhFromCurrentIdx-1].concat(circle[seventhFromCurrentIdx+1..circle.len()-1])
            currentMarbleIdx = seventhFromCurrentIdx  
            scoreRound += 1  
        else:
            circle = circle[0..marbleIdx-1].concat(@[i] ,circle[marbleIdx..circle.len()-1])
            currentMarbleIdx = marbleIdx
    echo circle
    echo scores.max
