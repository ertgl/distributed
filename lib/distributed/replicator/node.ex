defmodule Distributed.Replicator.Node do
	@moduledoc """
	The functions in `Distributed.Replicator.Node` module helps to replicate an event by processing it on the all nodes in the network.
	In `Distributed.Replicator.Node`, functions execute processes in parallel.

	**Note**: Since this module is only a wrapper for `Node` module, there is no need to write a detailed documentation for this module.
	Please check documentation of the `Node` module; you can basically think that the functions of the module run on every single node
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
		Distributed.Replicator.Node
	end

	@doc """
	Monitors the status of nodes.
	If flag is true, monitoring is turned on. If flag is false, monitoring is turned off.
	For more information, see `Node.monitor/2` and `Node.monitor/3`.
	"""
	@spec monitor(flag :: boolean, opts :: [any]) :: [true]
	def monitor(flag, opts \\ []) do
		Distributed.Parallel.map(Distributed.Node.list(opts), &(Node.monitor(&1, flag, opts)))
	end

	@doc """
	Tries to set up connections to nodes.
	"""
	@spec ping(opts :: [any]) :: [:pong | :pang]
	def ping(opts \\ []) do
		Distributed.Parallel.map(Distributed.Node.list(opts), &(Node.ping(&1)))
	end

	@doc """
	Returns the PIDs of new processes started by the application of `fun` on nodes.
	See `Node.spawn/2` and `Node.spawn/3`.
	"""
	@spec spawn(fun :: (() -> any), opts :: [any]) :: [pid | {pid, reference}]
	def spawn(fun, opts \\ [])
	when is_function(fun)
	do
		spawn_opts = Keyword.get(opts, :spawn_opts, [])
		Distributed.Parallel.map(Distributed.Node.list(opts), &(Node.spawn(&1, fun, spawn_opts)))
	end

	@doc """
	Returns the PIDs of new processes started by the application of `module.fun(args)` on nodes.
	See `Node.spawn/4` and `Node.spawn/5`.
	"""
	@spec spawn(module :: module, fun :: atom, args :: [any], opts :: [any]) :: [pid | {pid, reference}]
	def spawn(module, fun, args, opts \\ [])
	when is_atom(module)
	when is_atom(fun)
	do
		spawn_opts = Keyword.get(opts, :spawn_opts, [])
		Distributed.Parallel.map(Distributed.Node.list(opts), &(Node.spawn(&1, module, fun, args, spawn_opts)))
	end

	@doc """
	Returns the PIDs of new linked processes started by the application of `fun` on nodes.
	See `Node.spawn_link/2`.
	"""
	@spec spawn_link((() -> any)) :: [pid]
	def spawn_link(fun, opts \\ [])
	when is_function(fun)
	do
		Distributed.Parallel.map(Distributed.Node.list(opts), &(Node.spawn_link(&1, fun)))
	end

	@doc """
	Returns the PIDs of new linked processes started by the application of `module.function(args)` on nodes.
	See `Node.spawn_link/4`.
	"""
	@spec spawn_link(module :: module, fun :: atom, args :: [any], opts :: [any]) :: [pid]
	def spawn_link(module, fun, args, opts \\ [])
	when is_atom(module)
	when is_atom(fun)
	do
		Distributed.Parallel.map(Distributed.Node.list(opts), &(Node.spawn_link(&1, module, fun, args)))
	end

end
