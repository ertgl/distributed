defmodule Distributed.Application do
	# See http://elixir-lang.org/docs/stable/elixir/Application.html
	# for more information on OTP Applications
	@moduledoc false

	use Application

	def start(_type, _args) do
		import Supervisor.Spec, warn: false
		# Define workers and child supervisors to be supervised
		children = [
			# Starts a worker by calling: Distributed.Worker.start_link(arg1, arg2, arg3)
			# worker(Distributed.Worker, [arg1, arg2, arg3]),
			worker(Distributed.Node, []),
			worker(Distributed.Node.Iterator, []),
		]
		# See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
		# for other strategies and supported options
		opts = [
			name: Distributed.Supervisor,
			strategy: :one_for_one,
		]
		Supervisor.start_link(children, opts)
	end

end
