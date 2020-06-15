defmodule Swish.HTML.Components.Alert do
  alias Swish.HTML.Generator

  def alert(context, do: block) do
    alert(:div, context, block, [])
  end

  def alert(context, content) do
    alert(:div, context, content, [])
  end

  def alert(context, opts, do: block) when is_list(opts) do
    alert(:div, context, block, opts)
  end

  def alert(context, content, opts) when is_list(opts) do
    alert(:div, context, content, opts)
  end

  def alert(name, context, opts, do: block) when is_list(opts) do
    alert(name, context, block, opts)
  end

  def alert(name, context, content, opts) when is_list(opts) do
    Generator.build_alert(name, context, content, opts)
  end
end
