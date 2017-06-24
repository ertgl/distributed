defmodule Distributed.Node do
	@moduledoc """
	Functions in `Distributed.Node` module help to know which node is the master and which are the slaves.
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
		{:global, Distributed.Node}
	end

	@doc false
	def handle_call(:list, _from, state) do
		{:reply, Node.list() ++ [Node.self()], state}
	end

	@doc false
	def handle_call(:master, _from, state) do
		{:reply, Node.self(), state}
	end

	@doc false
	def handle_call(:slaves, _from, state) do
		{:reply, Node.list(), state}
	end

	@doc """
	Returns a list of names of all the nodes, including master. See also `Distributed.Node.Iterator`.
	"""
	@spec list(opts :: [any]) :: [atom]
	def list(opts \\ []) do
		timeout = Keyword.get(opts, :timeout, :infinity)
		GenServer.call(__MODULE__.process_id(), :list, timeout)
	end

	@doc """
	Returns name of the master node.
	"""
	@spec master(opts :: [any]) :: atom
	def master(opts \\ []) do
		timeout = Keyword.get(opts, :timeout, :infinity)
		GenServer.call(__MODULE__.process_id(), :master, timeout)
	end

	@doc """
	Returns a list of names of the slave nodes.
	"""
	@spec slaves(opts :: [any]) :: [atom]
	def slaves(opts \\ []) do
		timeout = Keyword.get(opts, :timeout, :infinity)
		GenServer.call(__MODULE__.process_id(), :slaves, timeout)
	end

	@doc """
	Returns true if the `node` is the master node, otherwise false.
	"""
	@spec is_master?(node :: atom, opts :: [any]) :: boolean
	def is_master?(node, opts \\ []) do
		node == __MODULE__.master(opts)
	end

	@doc """
	Returns true if the `node` is a slave node, otherwise false.
	"""
	@spec is_slave?(node :: atom, opts :: [any]) :: boolean
	def is_slave?(node, opts \\ []) do
		node in __MODULE__.slaves(opts)
	end

end
