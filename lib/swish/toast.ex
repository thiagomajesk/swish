defmodule Swish.Toast do
  @doc """
  A toast is a succint message that is displayed temporarily.

  ## Markup example

  ### Within a group

  ```heex
  <Swish.Toast.Group.root :let={group}>
    <Swish.Toast.root :let={toast} flash={@flash} kind={:info} group={group}>
      <Swish.Toast.title>Welcome to Swish!!</Swish.Toast.title>
      <Swish.Toast.description><%= toast.message %></Swish.Toast.description>
      <Swish.Toast.action>Confirm</Swish.Toast.action>
      <Swish.Toast.close>Close</Swish.Toast.close>
    </Swish.Toast.root>
  </Swish.Toast.Group.root>
  ```

  ### Without a group

  ```heex
  <Swish.Toast.root :let={toast} flash={@flash} kind={:info}>
    <Swish.Toast.title>Welcome to Swish!!</Swish.Toast.title>
    <Swish.Toast.description><%= toast.message %></Swish.Toast.description>
    <Swish.Toast.action>Confirm</Swish.Toast.action>
    <Swish.Toast.close>Close</Swish.Toast.close>
  </Swish.Toast.root>
  ```
  """
  @type t :: %Swish.Toast{}

  @enforce_keys [:id, :kind, :message]
  defstruct [:id, :kind, :flash, :message, :group, :js_show, :js_hide]

  use Phoenix.Component

  alias __MODULE__
  alias Swish.Toast.Group
  alias Phoenix.LiveView.JS

  @doc false
  def new(attrs \\ %{}) do
    js_module = Swish.JS.dynamic!()
    toast_id = System.unique_integer([:positive, :monotonic])

    kind = attrs[:kind] || :info
    flash = attrs[:flash] || %{}

    %Toast{
      id: attrs[:id] || "toast-#{toast_id}",
      kind: attrs[:kind] || :info,
      group: attrs[:group],
      message: attrs[:message] || Phoenix.Flash.get(flash, kind),
      js_show: Function.capture(js_module, :show_toast, 2),
      js_hide: Function.capture(js_module, :hide_toast, 2)
    }
  end

  attr(:id, :string, default: nil)
  attr(:toast, Toast, required: false)
  attr(:group, Group, required: false)
  attr(:flash, :map, default: %{})
  attr(:kind, :atom, values: [:info, :error])
  attr(:as, :string, default: "div")
  slot(:inner_block, required: true)
  attr(:rest, :global)

  def root(assigns) do
    assigns =
      assign_new(assigns, :toast, fn ->
        Toast.new(%{
          id: assigns.id,
          flash: assigns.flash,
          kind: assigns.kind,
          group: assigns.group
        })
      end)

    ~H"""
    <.dynamic_tag
      :if={@toast.message}
      id={@toast.id}
      role="alert"
      name={(@toast.group && "li") || @as}
      phx-mounted={show(@toast)}
      phx-click={hide(@toast)}
      tabindex="0"
      {@rest}
    >
      <%= render_slot(@inner_block, @toast) %>
    </.dynamic_tag>
    """
  end

  attr(:toast, Toast, required: false)
  attr(:as, :string, default: "h6")
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def title(assigns) do
    ~H"""
    <.dynamic_tag name={@as} {@rest}>
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end

  attr(:toast, Toast, required: false)
  attr(:as, :string, default: "p")
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def description(assigns) do
    ~H"""
    <.dynamic_tag name={@as} {@rest}>
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end

  attr(:rest, :global)
  slot(:inner_block, required: true)

  def close(assigns) do
    attrs = assigns_to_attributes(assigns.rest)
    attrs = Keyword.merge(attrs, aria_label: "Close")
    assigns = assign(assigns, :attrs, attrs)

    ~H"""
    <%= render_slot(@inner_block, @attrs) %>
    """
  end

  defp show(%Toast{js_show: fun} = toast, js \\ %JS{}), do: fun.(js, toast)
  defp hide(%Toast{js_hide: fun} = toast, js \\ %JS{}), do: fun.(js, toast)
end
