defmodule Swish.Dialog.Transitions do 
  @moduledoc false
  defstruct [:show_content, :hide_content, :show_backdrop, :hide_backdrop]
end

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
    <Swish.Dialog.backdrop dialog={dialog}>
  	  <Swish.Dialog.content dialog={dialog}>
  		  <Swish.Dialog.title dialog={dialog}>Welcome to Swish!</Swish.Dialog.title>
  			<Swish.Dialog.description dialog={dialog}>Swish is a UI toolkit for busy developers</Swish.Dialog.description>
        <p>Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.</p>
  		</Swish.Dialog.content>
    </Swish.Dialog.backdrop>
  </Swish.Dialog.portal>
  </Swish.Dialog.root>
  ```
  """

  @type t :: %Swish.Dialog{}

  @enforce_keys [:id, :portal_id, :open, :static, :close_delay, :open_delay, :transitions]
  defstruct [:id, :portal_id, :js_show, :js_hide, :open, :static,
    :close_delay, :open_delay, :transitions]

  use Phoenix.Component

  alias __MODULE__
  alias Swish.Dialog
  alias Phoenix.LiveView.JS

  @doc false
  def new() do
    js_module = Swish.JS.dynamic!()
    dialog_id = System.unique_integer([:positive, :monotonic])
    portal_id = System.unique_integer()

    %Dialog{
      id: "dialog-#{dialog_id}",
      portal_id: "portal-#{portal_id}",
      js_show: Function.capture(js_module, :show_dialog, 2),
      js_hide: Function.capture(js_module, :hide_dialog, 2),
      open: false,
      static: false,
      open_delay: 200,
      close_delay: 200,
      transitions: %Dialog.Transitions{}
    }
  end

  attr(:id, :string, required: false)
  attr(:open, :boolean, default: false)
  attr(:static, :boolean, default: false)
  attr(:open_delay, :integer, default: 200)
  attr(:close_delay, :integer, default: 200)
  attr(:transitions, Dialog.Transitions, default: %Dialog.Transitions{})

  attr(:dialog, Dialog, required: false)

  attr(:rest, :global)
  slot(:inner_block, required: true)

  def root(assigns) do
    assigns = assign_new(assigns, :dialog, fn ->
      %{ Dialog.new() | 
        open: assigns.open,
        static: assigns.static,
        open_delay: assigns.open_delay,
        close_delay: assigns.close_delay,
        transitions: assigns.transitions
      }
    end)

    ~H"""
    <div id={@dialog.id} {@rest}>
      <%= render_slot(@inner_block, @dialog) %>
    </div>
    """
  end

  attr(:dialog, Dialog, required: true)
  slot(:inner_block, required: true)

  def trigger(assigns) do
    assigns =
      assign(assigns, :attrs, %{
        "aria-haspopup" => "dialog",
        "phx-click" => JS.exec("data-show", to: "##{assigns.dialog.portal_id}"),
        "id" => "#{assigns.dialog.id}-trigger",
        "data-state" => open_to_state(assigns.dialog)
      })

    ~H"""
    <%= render_slot(@inner_block, @attrs) %>
    """
  end

  attr(:dialog, Dialog, required: true)
  slot(:inner_block, required: true)
  attr(:rest, :global)

  def backdrop(assigns) do
    assigns = assign(assigns, id: "#{assigns.dialog.id}-backdrop")

    ~H"""
    <div
      id={@id}
      data-state={open_to_state(@dialog)}
      aria-hidden="true"
      style="pointer-events: auto"
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr(:dialog, Dialog, required: true)
  slot(:inner_block, required: true)

  def close(assigns) do
    assigns =
      assign(assigns, :attrs, %{
        "aria-label" => "Close",
        "phx-click" => hide(assigns.dialog),
        "id" => "#{assigns.dialog.id}-close"
      })

    ~H"""
    <%= render_slot(@inner_block, @attrs) %>
    """
  end

  attr(:dialog, Dialog, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def content(assigns) do
    assigns = assign(assigns, id: "#{assigns.dialog.id}-content")

    ~H"""
    <.focus_wrap
      id={@id}
      phx-key={unless @dialog.static, do: "escape"}
      data-hide={unless @dialog.static, do: hide(@dialog)}
      phx-click-away={JS.exec("data-hide")}
      phx-window-keydown={JS.exec("data-hide")}
      aria-labelledby={"#{@dialog.id}-title"}
      aria-describedby={"#{@dialog.id}-description"}
      data-state={open_to_state(@dialog)}
      role="dialog"
      aria-modal="true"
      tabindex="-1"
      style="pointer-events: auto"
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.focus_wrap>
    """
  end

  attr(:as, :string, default: "h2")
  attr(:dialog, Dialog, required: true)
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
  attr(:dialog, Dialog, required: true)
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

  attr(:dialog, Dialog, required: true)
  attr(:target, :string, default: "body")
  attr(:update, :string, values: ~w(prepend append origin), default: "origin")

  slot(:inner_block, required: true)

  def portal(assigns) do
    ~H"""
    <Swish.Tag.portal
      data-show={show(@dialog)}
      id={@dialog.portal_id}
      target={@target}
      update={@update}
      close_delay={@dialog.close_delay}
      aria-hidden="true"
      phx-mounted={@dialog.open && JS.exec("data-show")}
    >
      <%= render_slot(@inner_block) %>
    </Swish.Tag.portal>
    """
  end

  defp show(%Dialog{js_show: fun} = dialog, js \\ %JS{}), do: fun.(js, dialog)
  defp hide(%Dialog{js_hide: fun} = dialog, js \\ %JS{}), do: fun.(js, dialog)

  defp open_to_state(%Dialog{open: open}) do
    case open do
      true -> "open"
      false -> "closed"
      _ -> raise "Expected boolean but received: #{inspect(open)}"
    end
  end
end
