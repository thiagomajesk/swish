defmodule Swish.HTML.Generator do

  alias Swish.HTML.Adapters.Bootstrap

  @adapter Application.get_env(:swish, :adapter, Bootstrap)

  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)
      import Phoenix.HTML.Tag
    end
  end

  @callback build_alert(name :: atom(), content :: any(), context :: atom(), opts :: []) :: {:safe, any()}
  defdelegate build_alert(name, content, context, opts), to: @adapter

  @callback build_badge(name :: atom(), content :: any(), context :: atom(), opts :: []) :: {:safe, any()}
  defdelegate build_badge(name, content, context, opts), to: @adapter
end
