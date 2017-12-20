defmodule Distributed.Replicator.GenServer do
	@moduledoc """
	The functions in `Distributed.Replicator.GenServer` module helps to replicate an event by processing it on the all nodes in the network.
	In `Distributed.Replicator.GenServer`, functions execute processes in parallel.

	**Note**: Since this module is only a wrapper for `GenServer` module, there is no need to write a detailed documentation for this module.
	Please check documentation of the `GenServer` module; you can basically think that the functions of the module run on every single node
	without specifying nodes, and you will be replied with a list of results of the processes.
	"""

	use GenServer

	@doc false
	def start_link() do
		 GenServer.start_link(__MODULE__, [], name: __MODULE__.process_id())
	end

	@doc false
	def init(_opts \\ []) do
		{:ok, %{}}
	end

	@doc false
	def process_id() do
		Distributed.Replicator.GenServer
	end

	@doc """
	Sends messages to the given dest on nodes and returns the message. See `Kernel.send/2`
	"""
	@spec info(dest :: pid | port | atom, msg :: any, opts :: [any]) :: any
	def info(dest, msg, opts \\ []) do
		Distributed.Parallel.map(Distributed.Node.list(opts), fn node_name ->
			{node_name, send({dest, node_name}, msg)}
		end)
	end

	@doc """
	Makes synchronous calls to the servers on nodes and waits for their replies. See `GenServer.call/3`
	"""
	@spec call(server :: atom, term, opts :: [any]) :: [term]
	def call(server, term, opts \\ []) do
		timeout = Keyword.get(opts, :timeout, :infinity)
		Distributed.Parallel.map(Distributed.Node.list(opts), fn node_name ->
			{node_name, GenServer.call({server, node_name}, term, timeout)}
		end)
	end

	@doc """
	Sends asynchronous requests to the servers on nodes. See `GenServer.cast/2`
	"""
	@spec cast(server :: atom, term :: term, opts :: [any]) :: [term]
	def cast(server, term, opts \\ []) do
		Distributed.Parallel.map(Distributed.Node.list(opts), fn node_name ->
			{node_name, GenServer.cast({server, node_name}, term)}
		end)
	end

end
