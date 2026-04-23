import Testing
@testable import Flow

struct FlowFallbackTests {
    @Test func fallbackNotCalledOnSuccess() async throws {
        let fallbackCalled = Box(false)
        let flow = Flow { 1 }.fallback {
            await fallbackCalled.set(true)
            return 2
        }

        let result = try await flow.run()
        #expect(result == 1)
        #expect(await fallbackCalled.value == false)
    }

    @Test func fallbackCalledOnPrimaryError() async throws {
        let flow = Flow<Int> { throw TestError.stub }.fallback { 42 }
        let result = try await flow.run()
        #expect(result == 42)
    }

    @Test func fallbackThrowsPrimaryErrorWhenBothFail() async throws {
        let primary = TestError.primary
        let flow = Flow<Int> { throw primary }.fallback { throw TestError.secondary }

        do {
            _ = try await flow.run()
            #expect(Bool(false), "Expected to throw but got value instead")
        } catch {
            #expect(error as? TestError == primary, "Expected primary error, got \(error) instead")
        }
    }
}
