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

    @Test func onErrorNotCalledOnSuccess() async throws {
        let actionCalled = Box(false)
        let flow = Flow { 1 }.onError { _ in await actionCalled.set(true) }

        _ = try await flow.run()
        #expect(await actionCalled.value == false)
    }
}
