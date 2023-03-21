defmodule Swish.Toast.Group do
  @type t :: %Swish.Toast.Group{}

  @enforce_keys [:id, :portal_id]
  defstruct [:id, :portal_id]

  use Phoenix.Component

  alias __MODULE__
  alias Phoenix.LiveView.JS

  @doc false
  def new() do
    group_id = System.unique_integer([:positive, :monotonic])
    portal_id = System.unique_integer()

    %Group{
      id: "toast-group-#{group_id}",
      portal_id: "portal-#{portal_id}"
    }
  end

  attr(:dialog, Group)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def root(assigns) do
    assigns = assign_new(assigns, :group, fn -> Group.new() end)

    ~H"""
    <Swish.Tag.portal id={@group.portal_id} phx-mounted={JS.dispatch("portal:open")}>
      <ol tabindex="-1" {@rest}>
        <%= render_slot(@inner_block, @group) %>
      </ol>
    </Swish.Tag.portal>
    """
  end
end
