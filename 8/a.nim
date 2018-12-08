import strutils
import sequtils
import strformat

# Node describes a node in the tree.
type 
    Node = ref object
        numChild: int
        numMeta: int
        children: seq[Node]
        metadata: seq[int]

# Parse node recursively traverses `input` to build the node tree.
# Also aggregates the sum of metadata for solution part a. 
proc parseNode(input: seq[int], idx: int, metaSum: var int): (Node, int) =
    let nC = input[idx]
    let nM = input[idx+1]
    var endIdx = idx
    let n = Node(
        numChild: nC,
        numMeta: nM,
        children : @[],
        metadata: @[]
    )

    # Increment the trailing idx here, to offset the header.
    endIdx += 2

    # If we have children, recursively parse them.
    if nC > 0:
        for x in countup(0, nC - 1):
            let cn = parseNode(input, endIdx, metaSum)
            n.children.add(cn[0])
            endIdx = cn[1]
    
    # Parse meta.
    # Guaranteed to have atleast one.
    for x in countup(endIdx, endIdx+nM-1):
        n.metadata.add(input[x])
        endIdx += 1
        metaSum += input[x]
    
    (n, endIdx)
    
when isMainModule:
    var
        f: File
        input: seq[int]
    if open(f, "input.txt"):
        input = readAll(f).split(" ").map(proc (x: string):int = parseInt(x))
    f.close()

    var metaSum = 0
    discard parseNode(input, 0, metaSum)

    echo &"sum of metadata is {metaSum}"
        