import sequtils
import strformat
import deques

# Much better solution from https://www.reddit.com/r/adventofcode/comments/a4i97s/2018_day_9_solutions/
# Way faster than the array manipulation I was doing in part A.
# The deque to maintain the circle is pretty elegant too.
# Lots of learning today :)
when isMainModule:
    const numPlayers = 493
    const lastMarble = 71863*100

    var circle = initDeque[int]()
    var scores : array[numPlayers, int]
    circle.addLast(0)
    for i in countup(1, lastMarble):
        if i.mod(23) == 0:
            for i in countup(0, 6):
                circle.addFirst(circle.popLast())
            scores[(i-1).mod(numPlayers)] += i + circle.popLast()
            circle.addLast(circle.popFirst())
        else:
            circle.addLast(circle.popFirst())
            circle.addLast(i)

    echo scores.max
