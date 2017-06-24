defmodule Distributed.Parallel do
	@moduledoc """
	The functions in `Distributed.Parallel` are not about scaling processes through all the nodes. They
	execute processes asynchronously on the node that uses the functions.

	If you want to execute processes through all nodes in parallel, please see `Distributed.Replication` module.
	"""

	@doc """
	Returns the results of new processes started by the application of `fun` on CPU cores.
	See https://en.wikipedia.org/wiki/Map_(parallel_pattern)
	"""
	@spec map(enumerable :: Enum.enumerable, fun :: (() -> any), opts :: [any]) :: [any]
	def map(enumerable, fun, opts \\ [])
	when is_function(fun)
	do
		timeout = Keyword.get(opts, :timeout, :infinity)
		Enum.map(enumerable, &(Task.async(fn -> fun.(&1) end)))
		|> Enum.map(&(Task.await(&1, timeout)))
	end

end
