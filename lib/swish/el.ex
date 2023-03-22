defmodule Swish.EL do
  @moduledoc false

  def new_id(prefix, escaped \\ false)
  def new_id(prefix, true), do: "##{prefix}-#{System.unique_integer([:positive])}"
  def new_id(prefix, false), do: "#{prefix}-#{System.unique_integer([:positive])}"

  def get_id(el, escaped \\ false)
  def get_id(%{id: id}, true), do: "##{id}"
  def get_id(%{id: id}, false), do: "#{id}"

  def suffix_id(el, suffix, escaped \\ false)
  def suffix_id(%{id: id}, suffix, true), do: "##{id}-#{suffix}"
  def suffix_id(%{id: id}, suffix, false), do: "#{id}-#{suffix}"

  def event(name), do: "swish:#{name}"
end
