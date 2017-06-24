defmodule Distributed.Replicator do

	defmacro __using__(opts \\ []) do
		node_opts = Keyword.get(opts, :node, [])
		gen_server_opts = Keyword.get(opts, :gen_server, [])

		quote do
			import(Distributed.Replicator.Node, unquote(node_opts))
			import(Distributed.Replicator.GenServer, unquote(gen_server_opts))
		end
	end

end
