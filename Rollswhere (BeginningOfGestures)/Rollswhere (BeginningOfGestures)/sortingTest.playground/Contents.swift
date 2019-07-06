

struct Thing {
    var num: Int
    init(num: Int) {
        self.num = num
    }
}

let numbers = [Thing(num: 3), Thing(num: 5), Thing(num: 4), Thing(num: 2), Thing(num: 6)]

print(numbers.sorted(by: { $0.num > $1.num }).map({ $0.num }))

