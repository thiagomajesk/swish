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
        trigger_target = Swish.EL.suffix_id(dialog, "trigger", true)
        backdrop_target = Swish.EL.suffix_id(dialog, "backdrop", true)
        content_target = Swish.EL.suffix_id(dialog, "content", true)

        js
        |> JS.dispatch("portal:open", to: "##{dialog.portal_id}")
        |> JS.set_attribute({"data-state", "open"}, to: trigger_target)
        |> JS.set_attribute({"data-state", "open"}, to: backdrop_target)
        |> JS.set_attribute({"data-state", "open"}, to: content_target)
        |> JS.set_attribute({"aria-expanded", "true"}, to: trigger_target)
        |> JS.show(
          to: backdrop_target,
          transition: dialog.transitions.show_backdrop,
          time: dialog.open_delay
        )
        |> JS.show(
          to: content_target,
          transition: dialog.transitions.show_content,
          time: dialog.open_delay
        )
        |> JS.focus_first(to: content_target)
      end

      def hide_dialog(js \\ %JS{}, %Swish.Dialog{} = dialog) do
        trigger_target = Swish.EL.suffix_id(dialog, "trigger", true)
        backdrop_target = Swish.EL.suffix_id(dialog, "backdrop", true)
        content_target = Swish.EL.suffix_id(dialog, "content", true)

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
        |> JS.set_attribute({"data-state", "closed"}, to: trigger_target)
        |> JS.set_attribute({"data-state", "closed"}, to: backdrop_target)
        |> JS.set_attribute({"data-state", "closed"}, to: content_target)
        |> JS.set_attribute({"aria-expanded", "false"}, to: trigger_target)
        |> JS.dispatch("portal:close", to: "##{dialog.portal_id}")
      end

      defoverridable Swish.JS
    end
  end
end
