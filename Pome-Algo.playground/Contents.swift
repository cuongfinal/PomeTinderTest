import UIKit

func solution(value1: Int, weight1: Int, value2: Int, weight2: Int, maxW: Int) -> Int {
    if weight1 + weight2 <= maxW {
        return value1 + value2
    } else if weight1 <= maxW && weight2 <= maxW {
        return max(value1, value2)
    } else if weight1 <= maxW {
        return value1
    } else if weight2 <= maxW {
        return value2
    } else {
        return 0
    }
}

print(solution(value1: 10, weight1: 5, value2: 4, weight2: 8, maxW: 8))
print(solution(value1: 10, weight1: 5, value2: 6, weight2: 4, maxW: 9))
print(solution(value1: 5, weight1: 3, value2: 7, weight2: 4, maxW: 6))
