defmodule Distributed.Mixfile do

	use Mix.Project

	def project() do
		[
			name: "Distributed",
			source_url: "https://github.com/ertgl/distributed",
			description: description(),
			package: package(),
			app: :distributed,
			version: "0.1.3",
			elixir: "~> 1.4",
			build_embedded: Mix.env() == :prod,
			start_permanent: Mix.env() == :prod,
			deps: deps(),
			docs: [
				main: "Distributed",
			],
		]
	end

	defp description() do
		"""
		Distributed is a wrapper module that helps developers to make distributed, scaled, replicated and fault-tolerant (with takeover ability) master-slave systems.
		"""
	end

	defp package() do
		[
			name: :distributed,
			files: [
				"lib",
				"mix.exs",
				"README.md",
				"LICENSE.txt",
			],
      	maintainers: [
			"Ertugrul Keremoglu <ertugkeremoglu@gmail.com>"
		],
		licenses: [
			"MIT",
		],
		links: %{
			"GitHub" => "https://github.com/ertgl/distributed",
		},
    ]
	end

	# Configuration for the OTP application
	#
	# Type "mix help compile.app" for more information
	def application() do
		# Specify extra applications you'll use from Erlang/Elixir
		[
			mod: {Distributed.Application, []},
			extra_applications: [
				:logger,
			],
		]
	end

	# Dependencies can be Hex packages:
	#
	#   {:my_dep, "~> 0.3.0"}
	#
	# Or git/path repositories:
	#
	#   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
	#
	# Type "mix help deps" for more examples and options
	defp deps() do
		[
			{:ex_doc, "~> 0.16.1", only: :dev},
		]
	end

end
