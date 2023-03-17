defmodule Swish.Dialog do
  @moduledoc """
  A dialog is a window overlaid on either the primary window or another dialog window.
  Windows under a modal dialog are inert. That is, users cannot interact with content outside an active dialog window.
  Inert content outside an active dialog is typically visually obscured or dimmed so it is difficult to discern,
  and in some implementations, attempts to interact with the inert content cause the dialog to close.

  ## ARIA design pattern
  https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/

  ## Markup example

  ```heex
  <Swish.Dialog.root :let={dialog}>
  <Swish.Dialog.trigger dialog={dialog} :let={attrs}>
    <button {attrs}>Open Dialog</button>
  </Swish.Dialog.trigger>
  <Swish.Dialog.portal dialog={dialog}>
    <Swish.Dialog.overlay dialog={dialog}>
  	  <Swish.Dialog.content dialog={dialog}>
  		  <Swish.Dialog.title dialog={dialog}>Welcome to Swish!</Swish.Dialog.title>
  			<Swish.Dialog.description dialog={dialog}>Swish is a UI toolkit for busy developers</Swish.Dialog.description>
        <p>Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.</p>
  		</Swish.Dialog.content>
    </Swish.Dialog.overlay>
  </Swish.Dialog.portal>
  </Swish.Dialog.root>
  ```
  """

  @type t :: %Swish.Dialog{}

  @enforce_keys [:id, :portal_id]
  defstruct [:id, :portal_id]

  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr(:id, :string, required: false)
  attr(:show, :boolean, default: false)
  attr(:dialog, __MODULE__, required: false)

  attr(:rest, :global)
  slot(:inner_block, required: true)

  def root(assigns) do
    assigns =
      assign_new(assigns, :id, fn ->
        "dialog-#{System.unique_integer([:positive, :monotonic])}"
      end)

    assigns =
      assign_new(assigns, :dialog, fn %{id: id} ->
        %__MODULE__{
          id: id,
          portal_id: "portal-#{System.unique_integer()}"
        }
      end)

    ~H"""
    <div id={@id} {@rest}>
      <%= render_slot(@inner_block, @dialog) %>
    </div>
    """
  end

  attr(:show, :boolean, default: false)
  attr(:dialog, __MODULE__, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def container(assigns) do
    assigns = assign(assigns, id: "#{assigns.dialog.id}-container")

    ~H"""
    <div id={@id} phx-mounted={@show && show(@dialog)} phx-remove={hide(@dialog.id)}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr(:dialog, __MODULE__, required: true)
  slot(:inner_block, required: true)

  def trigger(assigns) do
    assigns =
      assign(assigns, :attrs, %{
        "phx-click" => show(assigns.dialog),
        "id" => "#{assigns.dialog.id}-trigger"
      })

    ~H"""
    <%= render_slot(@inner_block, @attrs) %>
    """
  end

  attr(:dialog, __MODULE__, required: true)
  slot(:inner_block, required: true)
  attr(:rest, :global)

  def overlay(assigns) do
    assigns = assign(assigns, id: "#{assigns.dialog.id}-overlay")

    ~H"""
    <div id={@id} {@rest} aria-hidden="true">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr(:dialog, __MODULE__, required: true)
  slot(:inner_block, required: true)

  def close(assigns) do
    assigns =
      assign(assigns, :attrs, %{
        "phx-click" => hide(%JS{}, assigns.dialog),
        "id" => "#{assigns.dialog.id}-close"
      })

    ~H"""
    <%= render_slot(@inner_block, @attrs) %>
    """
  end

  attr(:dialog, __MODULE__, required: true)
  attr(:on_close, JS, default: %JS{})
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def content(assigns) do
    assigns = assign(assigns, id: "#{assigns.dialog.id}-content")

    ~H"""
    <.focus_wrap
      id={@id}
      phx-key="escape"
      phx-window-keydown={hide(@on_close, @dialog)}
      phx-click-away={hide(@on_close, @dialog)}
      role="dialog"
      aria-modal="true"
      tabindex="0"
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.focus_wrap>
    """
  end

  attr(:as, :string, default: "h2")
  attr(:dialog, __MODULE__, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def title(assigns) do
    assigns = assign(assigns, id: "#{assigns.dialog.id}-title")

    ~H"""
    <.dynamic_tag id={@id} name={@as} {@rest}>
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end

  attr(:as, :string, default: "p")
  attr(:dialog, __MODULE__, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def description(assigns) do
    assigns = assign(assigns, id: "#{assigns.dialog.id}-description")

    ~H"""
    <.dynamic_tag id={@id} name={@as} {@rest}>
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end

  attr(:dialog, __MODULE__, required: true)
  attr(:target, :string, default: "body")
  attr(:update, :string, values: ~w(prepend append origin), default: "origin")
  slot(:inner_block, required: true)

  def portal(assigns) do
    ~H"""
    <Swish.Tag.portal id={@dialog.portal_id} target={@target} update={@update}>
      <%= render_slot(@inner_block) %>
    </Swish.Tag.portal>
    """
  end

  defp show(js \\ %JS{}, dialog) do
    Swish.JS.dynamic!().show_dialog(js, dialog)
  end

  defp hide(js \\ %JS{}, dialog) do
    Swish.JS.dynamic!().hide_dialog(js, dialog)
  end
end
