import Config

if Mix.env() == :dev do
  esbuild = fn args ->
    [
      args: ~w(./index.js --bundle) ++ args,
      cd: Path.expand("../assets", __DIR__),
      env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
    ]
  end

  config :esbuild,
    version: "0.12.15",
    module: esbuild.(~w(--format=esm --sourcemap --outfile=../priv/static/swish.esm.js)),
    main: esbuild.(~w(--format=cjs --sourcemap --outfile=../priv/static/swish.cjs.js)),
    cdn: esbuild.(~w(--format=iife --target=es2016 --global-name=LiveView --outfile=../priv/static/swish.js)),
    cdn_min: esbuild.(~w(--format=iife --target=es2016 --global-name=LiveView --minify --outfile=../priv/static/swish.min.js))
end

