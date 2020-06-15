defmodule Swish.HTML.Components.Badge do
  alias Swish.HTML.Generator

  def badge(context, do: block) do
    badge(:span, context, block, [])
  end

  def badge(context, content) do
    badge(:span, context, content, [])
  end

  def badge(context, opts, do: block) when is_list(opts) do
    badge(:span, context, block, opts)
  end

  def badge(context, content, opts) when is_list(opts) do
    badge(:span, context, content, opts)
  end

  def badge(name, context, opts, do: block) when is_list(opts) do
    badge(name, context, block, opts)
  end

  def badge(name, context, content, opts) when is_list(opts) do
    Generator.build_badge(name, context, content, opts)
  end
end
