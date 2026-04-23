import Testing
@testable import Flow

struct FlowRunTests {
    @Test func runReturnsValueFromOperation() async throws {
        let flow = Flow { 42 }
        let result = try await flow.run()
        #expect(result == 42)
    }

    @Test func runThrowsWhenOperationThrows() async throws {
        let expected = TestError.stub
        let flow = Flow<Int> { throw expected }

        do {
            _ = try await flow.run()
            #expect(Bool(false), "Expected to throw but got value instead")
        } catch {
            #expect(error as? TestError == expected)
        }
    }

    @Test func callAsFunctionEquivalentToRun() async throws {
        let flow = Flow { "hello" }
        let viaRun = try await flow.run()
        let viaCall = try await flow()
        #expect(viaRun == viaCall)
    }
}
