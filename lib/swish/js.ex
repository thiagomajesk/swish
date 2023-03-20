defmodule Swish.JS do
  @moduledoc """
  Defines the behaviour for JS commands used by Swish components in your application.

  Although this module provides a default implementation for most commands used by the library,
  the user is encouraged to customize it by creating its implementations if necessary.
  """

  alias Phoenix.LiveView.JS

  @callback show_dialog(JS.t(), Swish.Dialog.t()) :: JS.t()
  @callback hide_dialog(JS.t(), Swish.Dialog.t()) :: JS.t()

  @doc false
  def dynamic! do
    Application.fetch_env!(:swish, :js)
  end

  defmacro __using__(_opts) do
    quote do
      @behaviour Swish.JS

      @impl true
      def show_dialog(js \\ %JS{}, %Swish.Dialog{} = dialog) do
        js
        |> JS.dispatch("portal:open", to: "##{dialog.portal_id}")
        |> JS.set_attribute({"data-state", "open"}, to: "##{dialog.id}-trigger")
        |> JS.set_attribute({"data-state", "open"}, to: "##{dialog.id}-backdrop")
        |> JS.set_attribute({"data-state", "open"}, to: "##{dialog.id}-content")
        |> JS.show(to: "##{dialog.id}-backdrop")
        |> JS.show(to: "##{dialog.id}-content")
        |> JS.focus_first(to: "##{dialog.id}-content")
      end

      @impl true
      def hide_dialog(js \\ %JS{}, %Swish.Dialog{} = dialog) do
        js
        |> JS.pop_focus()
        |> JS.hide(to: "##{dialog.id}-backdrop")
        |> JS.hide(to: "##{dialog.id}-content")
        |> JS.set_attribute({"data-state", "closed"}, to: "##{dialog.id}-trigger")
        |> JS.set_attribute({"data-state", "closed"}, to: "##{dialog.id}-backdrop")
        |> JS.set_attribute({"data-state", "closed"}, to: "##{dialog.id}-content")
        |> JS.dispatch("portal:close", to: "##{dialog.portal_id}")
      end

      defoverridable Swish.JS
    end
  end
end
