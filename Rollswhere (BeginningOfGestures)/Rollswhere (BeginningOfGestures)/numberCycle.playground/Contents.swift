

//: ## Cycling Through
//: The following code tests an algorithm meant to cycle through a list, this is specifically for the level selection scene which allows players to cycle though the list of levels. This means that players can navigate from level 1 straight to the highest unlocked level by going backwards.

let range = 1...5
let cycleVector = -2

// range: 1 2 3 4 5
// cycleVector = 5 -> i: 0 1 2 3 4
// cycleVector = -5 -> i: 0 4 3 2 1
// cycleVector = -10 -> i: 0 4 3 2 1 2 3 4 0 1

for i in 0..<abs(cycleVector) {
    let i = (cycleVector < 0 && (i % range.count) != 0) ? range.count - (i % range.count) : (i % range.count)
    Array(range)[i]
}


