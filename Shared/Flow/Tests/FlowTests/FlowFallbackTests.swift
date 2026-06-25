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

    @Test func fallbackThrowsSecondaryErrorWhenBothFail() async throws {
        let secondary = TestError.secondary
        let flow = Flow<Int> { throw TestError.primary }.fallback { throw secondary }

        do {
            _ = try await flow.run()
            #expect(Bool(false), "Expected to throw but got value instead")
        } catch {
            #expect(error as? TestError == secondary, "Expected secondary error, got \(error) instead")
        }
    }
    
    @Test func fallbackIsNotExecutedOnCancel() async throws {
        actor OnFallbackSpy {
            var called = false
            func setIsCalled() { called = true }
        }
        let onfallbackSpy = OnFallbackSpy()
        let started = AsyncStream<Void>.makeStream()
        
        let flow = Flow<Int> {
            started.continuation.yield()
            try await Task.sleep(for: .seconds(1))
            return 42
        }.fallback {
            await onfallbackSpy.setIsCalled()
            return 53
        }

        let task = Task { try await flow.run() }
        for await _ in started.stream { break }
        task.cancel()
        
        do {
            _ = try await task.value
            Issue.record("Expected CancellationError")
        } catch {
            #expect(error is CancellationError)
        }
        #expect(await onfallbackSpy.called == false)
    }
}
