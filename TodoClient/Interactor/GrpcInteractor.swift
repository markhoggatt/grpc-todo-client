//
//  GrpcInteractor.swift
//  TodoClient
//
//  Created by Mark Hoggatt on 28/05/2023.
//

import Foundation
import GRPC
import NIOCore

struct GrpcInteractor
{
	fileprivate let group: EventLoopGroup

	init()
	{
		group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
	}

	func retrieveTodos() async -> [Todo]
	{
		defer { close() }

		do
		{
			let todoClient: Todos_TodoServiceAsyncClient = try buildTodoClient()

			let todos: Todos_TodoList = try await todoClient.fetchTodos(Todos_Empty())

			return todos.todos.map { Todo(id: UUID(uuidString: $0.todoID) ?? UUID(), title: $0.title) }
		}
		catch
		{
			print("Retrieve todos failed: \(error.localizedDescription)")
		}

		return []
	}

	func createTodo(from newTodo: Todo) async -> Todo
	{
		defer { close() }

		do
		{
			let todoClient: Todos_TodoServiceAsyncClient = try buildTodoClient()
			var grpcTodo = Todos_Todo()
			grpcTodo.title = newTodo.title

			let created: Todos_Todo = try await todoClient.createTodo(grpcTodo)

			return Todo(id: UUID(uuidString: created.todoID) ?? UUID(), title: created.title)
		}
		catch
		{
			print("Retrieve todos failed: \(error.localizedDescription)")
		}

		return newTodo
	}

	fileprivate func close()
	{
		do
		{
			try group.syncShutdownGracefully()
		}
		catch
		{
			print("Failed to shut down the event loop: \(error.localizedDescription)")
		}
	}

	fileprivate func buildTodoClient() throws -> Todos_TodoServiceAsyncClient
	{
		let channel: GRPCChannel = try GRPCChannelPool.with(target: .hostAndPort("localhost", 1234),
															transportSecurity: .plaintext,
															eventLoopGroup: group)

		return Todos_TodoServiceAsyncClient(channel: channel)
	}
}
