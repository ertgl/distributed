defmodule Distributed.Scaler.Node do
	@moduledoc """
	The functions in `Distributed.Scaler.Node` module helps to scale projects by processing every event on the next node, in order.

	**Note**: Since this module is only a wrapper for `Node` module, there is no need to write a detailed documentation for this module.
	Please check documentation of the `Node` module; you can basically think that the functions of the module run on the next node
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
		Distributed.Scaler.Node
	end

	@doc """
	Returns the PID of a new process started by the application of `fun` on the next node.
	See `Node.spawn/2` and `Node.spawn/3`.
	"""
	@spec spawn(fun :: (() -> any), opts :: [any]) :: pid | {pid, reference}
	def spawn(fun, opts \\ [])
	when is_function(fun)
	do
		spawn_opts = Keyword.get(opts, :spawn_opts, [])
		Node.spawn(Distributed.Node.Iterator.next(), fun, spawn_opts)
	end

	@doc """
	Returns the PID of a new process started by the application of `module.fun(args)` on the next node.
	See `Node.spawn/4` and `Node.spawn/5`.
	"""
	@spec spawn(module :: module, fun :: atom, args :: [any], opts :: [any]) :: pid | {pid, reference}
	def spawn(module, fun, args, opts \\ [])
	when is_atom(module)
	when is_atom(fun)
	do
		spawn_opts = Keyword.get(opts, :spawn_opts, [])
		Node.spawn(Distributed.Node.Iterator.next(), module, fun, args, spawn_opts)
	end

	@doc """
	Returns the PID of a new linked process started by the application of `fun` on the next node.
	See `Node.spawn_link/2`.
	"""
	@spec spawn_link((() -> any)) :: pid
	def spawn_link(fun)
	when is_function(fun)
	do
		Node.spawn_link(Distributed.Node.Iterator.next(), fun)
	end

	@doc """
	Returns the PID of a new linked process started by the application of `module.function(args)` on the next node.
	See `Node.spawn_link/4`.
	"""
	@spec spawn_link(module :: module, fun :: atom, args :: [any]) :: pid
	def spawn_link(module, fun, args)
	when is_atom(module)
	when is_atom(fun)
	do
		Node.spawn_link(Distributed.Node.Iterator.next(), module, fun, args)
	end

end
