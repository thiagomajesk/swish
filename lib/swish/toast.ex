defmodule Swish.Toast do
  @doc """
  A toast is a succint message that is displayed temporarily.

  ## Markup example

  ```heex
  <Swish.Toast.portal>
    <Swish.Toast.group :let={group}>
      <Swish.Toast.root flash={@flash} kind={:info} :let={toast} group={group}>
        <Swish.Toast.title>Welcome to Swish!!</Swish.Toast.title>
        <Swish.Toast.description><%= toast.message %></Swish.Toast.description>
        <Swish.Toast.action>Confirm</Swish.Toast.action>
        <Swish.Toast.close>Close</Swish.Toast.close>
      </Swish.Toast.root>
    </Swish.Toast.group>
  </Swish.Toast.portal>
  ```
  """
  @type t :: %Swish.Dialog{}

  @enforce_keys [:id, :portal_id, :message]
  defstruct [:id, :portal_id, :message]

  use Phoenix.Component

  alias Phoenix.LiveView.JS

  attr(:target, :string, default: "body")
  attr(:update, :string, values: ~w(prepend append origin), default: "origin")
  slot(:inner_block, required: true)

  def portal(assigns) do
    ~H"""
    <Swish.Tag.portal id={@flash.portal_id} target={@target} update={@update}>
      <%= render_slot(@inner_block) %>
    </Swish.Tag.portal>
    """
  end

  attr(:duration, :integer, default: 500)
  attr(:swipe_direction, :string, values: ~w(right left up down))
  attr(:swipe_threshold, :integer, default: 50)
  slot(:inner_block, required: true)

  def group(assigns) do
    assigns =
      assign(assigns, :group, %{
        id: System.unique_integer([:positive]),
        next_index: Function.capture(__MODULE__, :next_tabindex, 0)
      })

    ~H"""
    <ol tabindex="-1">
      <%= render_slot(@inner_block, @group) %>
    </ol>
    """
  end

  attr(:id, :string, default: "flash")
  attr(:toast, __MODULE__, required: false)
  attr(:group, :map, required: false)
  attr(:flash, :map, default: %{})
  attr(:kind, :atom, values: [:info, :error])
  attr(:autoshow, :boolean, default: true)
  attr(:close, :boolean, default: true)
  attr(:duration, :integer, default: 500)
  attr(:tabindex, :integer, default: -1)
  attr(:swipe_direction, :string, values: ~w(right left up down))
  attr(:swipe_threshold, :integer, default: 50)
  attr(:as, :string, default: "div")
  slot(:inner_block, required: true)
  attr(:rest, :global)

  def root(assigns) do
    assigns =
      assign_new(assigns, :toast, fn ->
        %__MODULE__{
          id: "toast-#{System.unique_integer()}",
          portal_id: "portal-#{System.unique_integer()}",
          message: Phoenix.Flash.get(assigns.flash, assigns.kind)
        }
      end)

    ~H"""
    <.dynamic_tag
      :if={@toast.message}
      id={@id}
      role="alert"
      name={(@group && "li") || @as}
      tabindex={@group && @group.next_index.() && @tabindex}
    >
      <%= render_slot(@inner_block, @toast) %>
    </.dynamic_tag>
    """
  end

  attr(:toast, __MODULE__, required: false)
  attr(:as, :string, default: "h6")
  slot(:inner_block, required: true)

  def title(assigns) do
    ~H"""
    <.dynamic_tag name={@as}>
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end

  attr(:toast, __MODULE__, required: false)
  attr(:as, :string, default: "p")
  slot(:inner_block, required: true)

  def description(assigns) do
    ~H"""
    <.dynamic_tag name={@as}>
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end

  slot(:inner_block, required: true)

  def close(assigns) do
    ~H"""
    <%= render_slot(@inner_block) %>
    """
  end

  slot(:inner_block, required: true)

  def action(assigns) do
    ~H"""
    <%= render_slot(@inner_block) %>
    """
  end

  @doc false
  def next_tabindex() do
    System.unique_integer([:positive, :monotonic])
  end

  defp show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  defp hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end
end
