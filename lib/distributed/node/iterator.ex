defmodule Distributed.Node.Iterator do
	@moduledoc """
	Functions in `Distributed.Node.Iterator` module help to iterate through all the nodes connected.
	"""

	use GenServer

	@doc false
	def start_link() do
		 GenServer.start_link(__MODULE__, [], name: __MODULE__.process_id())
	end

	@doc false
	def init(_opts \\ []) do
		{
			:ok,
			%{
				previous_nodes: [],
			},
		}
	end

	@doc false
	def process_id() do
		{:global, __MODULE__}
	end

	@doc false
	def handle_call({:next, opts}, _from, %{previous_nodes: previous_nodes} = state) do
		skip_master = Keyword.get(opts, :skip_master, false)
		no_sweep = Keyword.get(opts, :no_sweep, false)
		nodes = case skip_master do
			true ->
				Distributed.Node.list() -- [Distributed.Node.master()] -- previous_nodes
			false ->
				Distributed.Node.list() -- previous_nodes
		end
		{need_to_repeat?, available_nodes} = case length(nodes) > 0 do
			true ->
				{false, nodes}
			false ->
				{true, Distributed.Node.list()}
		end
		next_node = List.first(available_nodes)
		timely_previous_nodes = case need_to_repeat? do
			false ->
				previous_nodes ++ [next_node]
			true ->
				[next_node]
		end
		case no_sweep do
			true ->
				{:reply, next_node, state}
			false ->
				{:reply, next_node, Map.put(state, :previous_nodes, timely_previous_nodes)}
		end
	end

	@doc """
	Returns the next node's name in the iteration. When the iteration ends, it will repeat itself lazily.

	You can skip the master node via:
		skip_master: true

	Note: `skip_master` will not work if the master node is the only node in the network.

	You can also know which one the next node, without touching the order via:
		no_sweep: true
	"""
	@spec next(opts :: [any]) :: atom
	def next(opts \\ []) do
		timeout = Keyword.get(opts, :timeout, :infinity)
		GenServer.call(__MODULE__.process_id(), {:next, opts}, timeout)
	end

end
