import Testing
@testable import Flow

struct FlowOnErrorTests {
    @Test func onErrorCalledWithCorrectError() async throws {
        let received = Box<TestError?>(nil)
        let flow = Flow<Int> { throw TestError.stub }.onError { await received.set($0 as? TestError) }

        _ = try? await flow.run()
        #expect(await received.value == .stub)
    }

    @Test func onErrorRethrowsError() async throws {
        let expected = TestError.stub
        let flow = Flow<Int> { throw expected }.onError { _ in }

        do {
            _ = try await flow.run()
            #expect(Bool(false), "Expected to throw but got value instead")
        } catch {
            #expect(error as? TestError == expected)
        }
    }
    
    @Test func onErrorThrowsCancellationErrorWhenCancelled() async throws {
        actor OnErrorSpy {
            var called = false
            func setOnErrorCalled() { called = true }
        }
        let onErrorSpy = OnErrorSpy()
        let started = AsyncStream<Void>.makeStream()
        
        let flow = Flow<Int> {
            started.continuation.yield()
            try await Task.sleep(for: .seconds(1))
            return 0
        }.onError { _ in
            await onErrorSpy.setOnErrorCalled()
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
        #expect(await onErrorSpy.called == false)
    }

    @Test func onErrorNotCalledOnSuccess() async throws {
        let actionCalled = Box(false)
        let flow = Flow { 1 }.onError { _ in await actionCalled.set(true) }

        _ = try await flow.run()
        #expect(await actionCalled.value == false)
    }
}
