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

      def show_dialog(js \\ %JS{}, %Swish.Dialog{} = dialog) do
        js
        |> JS.dispatch("portal:open", to: "##{dialog.portal_id}")
        |> JS.set_attribute({"data-state", "open"}, to: "##{dialog.id}-trigger")
        |> JS.set_attribute({"data-state", "open"}, to: "##{dialog.id}-backdrop")
        |> JS.set_attribute({"data-state", "open"}, to: "##{dialog.id}-content")
        |> JS.set_attribute({"aria-expanded", "true"}, to: "##{dialog.id}-trigger")
        |> JS.show(
          to: "##{dialog.id}-backdrop",
          transition: dialog.transitions.show_backdrop,
          time: dialog.open_delay
        )
        |> JS.show(
          to: "##{dialog.id}-content",
          transition: dialog.transitions.show_content,
          time: dialog.open_delay
        )
        |> JS.focus_first(to: "##{dialog.id}-content")
      end

      def hide_dialog(js \\ %JS{}, %Swish.Dialog{} = dialog) do
        js
        |> JS.pop_focus()
        |> JS.hide(
          to: "##{dialog.id}-backdrop",
          transition: dialog.transitions.hide_backdrop,
          time: dialog.close_delay
        )
        |> JS.hide(
          to: "##{dialog.id}-content",
          transition: dialog.transitions.hide_content,
          time: dialog.close_delay
        )
        |> JS.set_attribute({"data-state", "closed"}, to: "##{dialog.id}-trigger")
        |> JS.set_attribute({"data-state", "closed"}, to: "##{dialog.id}-backdrop")
        |> JS.set_attribute({"data-state", "closed"}, to: "##{dialog.id}-content")
        |> JS.set_attribute({"aria-expanded", "false"}, to: "##{dialog.id}-trigger")
        |> JS.dispatch("portal:close", to: "##{dialog.portal_id}")
      end

      defoverridable Swish.JS
    end
  end
end
