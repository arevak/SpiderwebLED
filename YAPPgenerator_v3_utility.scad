function generateLinearHoles(startPos, numHoles, holeDiameter, minCenterDistance, shellLength, padding = 2, rotation = 0, coordSystem = yappCoordBoxInside) =
let(
    maxWidth = shellLength - (2 * padding) - holeDiameter,
    minWidth = (numHoles - 1) * minCenterDistance,
    isPossible = maxWidth >= minWidth,
    actualCenterDistance = isPossible ? max(minCenterDistance, maxWidth / (numHoles - 1)) : 0,
    totalWidth = (numHoles - 1) * actualCenterDistance,
    adjustedStartPos = startPos + padding + (maxWidth - totalWidth) / 2 + holeDiameter/2,
    dummy = echo(str("Debug: Actual center-to-center distance: ", actualCenterDistance, "mm"))
)
isPossible ?
[
    for (i = [0:numHoles-1])
        let(holePos = adjustedStartPos + i * actualCenterDistance)
        [
            holePos,        // from Back
            6,              // from Left
            0,              // width (0 for circles)
            11,             // length (11 for compatibility with previous example)
            holeDiameter/2, // radius
            yappCircleWithFlats, // shape
            0,              // depth (0 = Auto)
            rotation,       // angle (now using the rotation parameter)
            coordSystem,    // coordinate system
            yappCenter      // centering option
        ]
] :
(
    echo(str("Error: Not enough space for ", numHoles, " holes of diameter ", holeDiameter, 
             " with minimum center distance ", minCenterDistance, 
             " and padding ", padding, " in shell length ", shellLength, "."))
    []
);