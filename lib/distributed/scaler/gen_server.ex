defmodule Distributed.Scaler.GenServer do
	@moduledoc """
	The functions in `Distributed.Scaler.GenServer` module helps to scale projects by processing every event on the next node, in order.

	**Note**: Since this module is only a wrapper for `GenServer` module, there is no need to write a detailed documentation for this module.
	Please check documentation of the `GenServer` module; you can basically think that the functions of the module run on the next node
	without specifying the node, and you will be replied with the result of the process.

	You can use this module mostly for read operations, loop actions or background tasks. It is suitable when you do not need replication
	of events.
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
		Distributed.Scaler.GenServer
	end

	@doc """
	Sends messages to the given dest on nodes and returns the message. See `Kernel.send/2`
	"""
	@spec info(dest :: pid | port | atom, msg :: any) :: any
	def info(dest, msg) do
		send({dest, Distributed.Node.Iterator.next()}, msg)
	end

	@doc """
	Makes synchronous calls to the servers on nodes and waits for their replies. See `GenServer.call/3`
	"""
	@spec call(server :: atom, term, opts :: [any]) :: term
	def call(server, term, opts \\ []) do
		timeout = Keyword.get(opts, :timeout, :infinity)
		GenServer.call({server, Distributed.Node.Iterator.next()}, term, timeout)
	end

	@doc """
	Sends asynchronous requests to the servers on nodes. See `GenServer.cast/2`
	"""
	@spec cast(server :: atom, term :: term) :: term
	def cast(server, term) do
		GenServer.cast({server, Distributed.Node.Iterator.next()}, term)
	end

end
