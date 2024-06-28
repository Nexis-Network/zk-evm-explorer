defmodule BlockScoutWeb.Mixfile do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      app: :block_scout_web,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps: deps(),
      deps_path: "../../deps",
      description: "Web interface for BlockScout.",
      dialyzer: [
        plt_add_deps: :app_tree,
        ignore_warnings: "../../.dialyzer-ignore"
      ],
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env(), Application.get_env(:block_scout_web, :disable_api?)),
      lockfile: "../../mix.lock",
      package: package(),
      preferred_cli_env: [
        credo: :test,
        dialyzer: :test
      ],
      start_permanent: Mix.env() == :prod,
      version: "6.7.0",
      xref: [
        exclude: [
          Explorer.Chain.PolygonZkevm.Reader,
          Explorer.Chain.Beacon.Reader,
          Explorer.Chain.Cache.OptimismFinalizationPeriod,
          Explorer.Chain.Optimism.OutputRoot,
          Explorer.Chain.Optimism.WithdrawalEvent,
          Explorer.Chain.ZkSync.Reader,
          Explorer.Chain.Arbitrum.Reader
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {BlockScoutWeb.Application, []},
      extra_applications: extra_applications()
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test, _), do: ["test/support", "test/block_scout_web/features/pages"] ++ elixirc_paths()

  defp elixirc_paths(_, true),
    do: [
      "lib/phoenix",
      "lib/block_scout_web.ex",
      "lib/block_scout_web/application.ex",
      "lib/block_scout_web/endpoint.ex",
      "lib/block_scout_web/health_router.ex",
      "lib/block_scout_web/controllers/api/v1/health_controller.ex"
    ]

  defp elixirc_paths(_, _), do: elixirc_paths()
  defp elixirc_paths, do: ["lib"]

  defp extra_applications,
    do: [
      :ueberauth_auth0,
      :logger,
      :runtime_tools
    ]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # GraphQL toolkit
      {:absinthe, "~> 1.5"},
      # Integrates Absinthe subscriptions with Phoenix
      {:absinthe_phoenix, "~> 2.0.0"},
      # Plug support for Absinthe
      {:absinthe_plug, git: "https://github.com/blockscout/absinthe_plug.git", tag: "1.5.8", override: true},
      # Absinthe support for the Relay framework
      {:absinthe_relay, "~> 1.5"},
      {:bypass, "~> 2.1", only: :test},
      # To add (CORS)(https://www.w3.org/TR/cors/)
      {:cors_plug, "~> 3.0"},
      {:credo, "~> 1.5", only: :test, runtime: false},
      # For Absinthe to load data in batches
      {:dataloader, "~> 1.0.0"},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      # Need until https://github.com/absinthe-graphql/absinthe_relay/pull/125 is released, then can be removed
      # The current `absinthe_relay` is compatible though as shown from that PR
      {:ecto, "~> 3.3", override: true},
      {:ex_cldr, "~> 2.38"},
      {:ex_cldr_numbers, "~> 2.33"},
      {:ex_cldr_units, "~> 3.17"},
      {:cldr_utils, "~> 2.3"},
      {:ex_machina, "~> 2.1", only: [:test]},
      {:explorer, in_umbrella: true},
      {:exvcr, "~> 0.10", only: :test},
      {:file_info, "~> 0.0.4"},
      # HTML CSS selectors for Phoenix controller tests
      {:floki, "~> 0.31"},
      {:flow, "~> 1.2"},
      {:gettext, "~> 0.24.0"},
      {:hammer, "~> 6.0"},
      {:httpoison, "~> 2.0"},
      {:indexer, in_umbrella: true, runtime: false},
      # JSON parser and generator
      {:jason, "~> 1.3"},
      {:junit_formatter, ">= 0.0.0", only: [:test], runtime: false},
      # Log errors and application output to separate files
      {:logger_file_backend, "~> 0.0.10"},
      {:math, "~> 0.7.0"},
      {:mock, "~> 0.3.0", only: [:test], runtime: false},
      {:number, "~> 1.0.1"},
      {:phoenix, "== 1.5.14"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_html, "== 3.0.4"},
      {:phoenix_live_reload, "~> 1.2", only: [:dev]},
      {:phoenix_pubsub, "~> 2.0"},
      {:prometheus_ex, git: "https://github.com/lanodan/prometheus.ex", branch: "fix/elixir-1.14", override: true},
      # use `:cowboy` for WebServer with `:plug`
      {:plug_cowboy, "~> 2.2"},
      # Waiting for the Pretty Print to be implemented at the Jason lib
      # https://github.com/michalmuskala/jason/issues/15
      {:poison, "~> 5.0.0"},
      {:postgrex, ">= 0.0.0"},
      # For compatibility with `prometheus_process_collector`, which hasn't been updated yet
      {:prometheus, "~> 4.0", override: true},
      # Gather methods for Phoenix requests
      {:prometheus_phoenix, "~> 1.2"},
      # Expose metrics from URL Prometheus server can scrape
      {:prometheus_plugs, "~> 1.1"},
      # OS process metrics for Prometheus
      {:prometheus_process_collector, "~> 1.3"},
      {:remote_ip, "~> 1.0"},
      {:qrcode, "~> 0.1.0"},
      {:sobelow, ">= 0.7.0", only: [:dev, :test], runtime: false},
      # Tracing
      {:spandex, "~> 3.0"},
      # `:spandex` integration with Datadog
      {:spandex_datadog, "~> 1.0"},
      # `:spandex` tracing of `:phoenix`
      {:spandex_phoenix, "~> 1.0"},
      {:timex, "~> 3.7.1"},
      {:wallaby, "~> 0.30", only: :test, runtime: false},
      # `:cowboy` `~> 2.0` and Phoenix 1.4 compatibility
      {:websocket_client, git: "https://github.com/blockscout/websocket_client.git", branch: "master", override: true},
      {:ex_json_schema, "~> 0.10.1"},
      {:ueberauth, "~> 0.7"},
      {:ueberauth_auth0, "~> 2.0"},
      {:bureaucrat, "~> 0.2.9", only: :test},
      {:logger_json, "~> 5.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      compile: "compile --warnings-as-errors",
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        "ecto.create --quiet",
        "ecto.migrate",
        # to match behavior of `mix test` from project root, which needs to not start applications for `indexer` to
        # prevent its supervision tree from starting, which is undesirable in test
        "test --no-start"
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Blockscout"],
      licenses: ["GPL 3.0"],
      links: %{"GitHub" => "https://github.com/blockscout/blockscout"}
    ]
  end
end
