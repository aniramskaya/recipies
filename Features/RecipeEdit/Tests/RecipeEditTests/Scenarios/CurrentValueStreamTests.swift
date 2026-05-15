//
//  CurrentValueStreamTests.swift
//  RecipeEdit
//
//  Created by Марина Чемезова on 15.05.2026.
//

import Testing
import Foundation
import RecipeEdit

struct CurrentValueStreamTests {
    @Test
    @MainActor
    func currentValueStream() async throws {
        let stream = CurrentValueStream(10)
    
        var values1: [Int] = []
        
        let started1 = AsyncStream<Void>.makeStream()
        
        let collectTask1 = Task {
            let asyncStream = await stream.makeStream()
            started1.continuation.yield(())
            for await item in asyncStream {
                values1.append(item)
            }
        }

        for await _ in started1.stream {
            break
        }
        
        await stream.yield(20)
        
        var values2: [Int] = []
        
        let started2 = AsyncStream<Void>.makeStream()
        
        let collectTask2 = Task {
            let asyncStream = await stream.makeStream()
            started2.continuation.yield(())
            for await item in asyncStream {
                values2.append(item)
            }
        }

        for await _ in started2.stream {
            break
        }
        
        await stream.yield(30)
        await stream.finish()
        
        await collectTask1.value
        await collectTask2.value
                
        #expect(values1 == [10, 20, 30])
        #expect(values2 == [20, 30])
    }
}
