import Testing
@testable import Flow

struct FlowMapTests {
    @Test func mapTransformsValue() async throws {
        let flow = Flow { 2 }.map { $0 * 10 }
        let result = try await flow.run()
        #expect(result == 20)
    }

    @Test func mapPropagatesError() async throws {
        let expected = TestError.stub
        let flow = Flow<Int> { throw expected }.map { $0 * 10 }

        do {
            _ = try await flow.run()
            #expect(Bool(false), "Expected to throw but got value instead")
        } catch {
            #expect(error as? TestError == expected)
        }
    }

    @Test func mapIsNotCalledOnError() async throws {
        let mapCalled = Box(false)
        let flow = Flow<Int> { throw TestError.stub }.map { value -> Int in
            await mapCalled.set(true)
            return value
        }

        _ = try? await flow.run()
        #expect(await mapCalled.value == false)
    }
}
