### [Distributed](https://github.com/ertgl/distributed)

Make your systems distributed, replicated, scaled well, easily.

[![Hex Version](https://img.shields.io/hexpm/v/distributed.svg?style=flat-square)](https://hex.pm/packages/distributed) [![Docs](https://img.shields.io/badge/api-docs-orange.svg?style=flat-square)](https://hexdocs.pm/distributed) [![Hex downloads](https://img.shields.io/hexpm/dt/distributed.svg?style=flat-square)](https://hex.pm/packages/distributed) [![GitHub](https://img.shields.io/badge/vcs-GitHub-blue.svg?style=flat-square)](https://github.com/ertgl/distributed) [![MIT License](https://img.shields.io/hexpm/l/distributed.svg?style=flat-square)](LICENSE.txt)
---

### Tutorial

This is an example of a replicated `GenServer`.

```elixir
defmodule Storage.KV do

	use GenServer

	def start_link() do
		GenServer.start_link(__MODULE__, [initial_state: %{}], name: __MODULE__.process_id())
	end

	def init(opts \\ []) do
		{:ok, Keyword.get(opts, :initial_state, %{})}
	end

	def process_id() do
		Storage.KV
	end

	def handle_cast({:set, key, value}, state) do
		{:noreply, Map.put(state, key, value)}
	end

	def handle_call({:get, key, default}, _from, state) do
		{:reply, Map.get(state, key, default), state}
	end

	def handle_call({:has, key}, _from, state) do
		{:reply, Map.has_key?(state, key), state}
	end

	def handle_call({:pop, key, default}, _from, state) do
		{value, new_state} = Map.pop(state, key, default)
		{:reply, value, new_state}
	end

	def get(key, default \\ nil) do
		Distributed.Scaler.GenServer.call(__MODULE__.process_id(), {:get, key, default})
	end

	def set(key, value) do
		{_node_name, result} = Distributed.Replicator.GenServer.cast(__MODULE__.process_id(), {:set, key, value})
			|> List.first()
		result
	end

	def has?(key) do
		Distributed.Scaler.GenServer.call(__MODULE__.process_id(), {:has, key})
	end

	def pop(key, default \\ nil) do
		{_node_name, result} = Distributed.Replicator.GenServer.call(__MODULE__.process_id(), {:pop, key, default})
			|> List.first()
		result
	end

end
```

You can see the example as a small project on [ertgl/storage](https://github.com/ertgl/storage) repository.


### Installation:

If [you have Hex](https://hex.pm), the package can be installed
by adding `:distributed` to your list of dependencies in `mix.exs`:

```elixir
def application do
	[
		extra_applications: [
			:distributed,
		],
	]
end

def deps do
	[
		{:distributed, "~> 0.1.0"},
	]
end
```
