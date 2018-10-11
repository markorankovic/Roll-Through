import Foundation
import CoreGraphics

struct Level: Codable {
    let fixedBlocks: [CGRect]
    let blocks: [CGRect]
    let pipe: CGRect
    let goal: CGRect
}

let json = """
{
  "fixedBlocks": [[[10, 10], [100, 20]], [[300, 10], [100, 20]]],
  "blocks": [[[100, 100], [20, 50]], [[100, 200], [20, 50]]],
  "pipe": [[0, 10], [10, 20]],
  "goal": [[200, 400], [50, 200]]
}
"""

let model = try! JSONDecoder().decode(Level.self, from: json.data(using: .utf8)!)

let data = try! JSONEncoder().encode(model)

print(String(data: data, encoding: .utf8)!)

