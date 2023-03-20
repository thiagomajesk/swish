defmodule Swish.Tag do
  use Phoenix.Component

  @input_types ~w(checkbox color date datetime-local email file hidden month number password
  range radio search tel text time url week)

  attr(:for, :string, default: nil)
  slot(:inner_block, required: false)
  attr(:rest, :global)

  def label(assigns) do
    ~H"""
    <label for={@for} {@rest}>
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  attr(:id, :any, default: nil)
  attr(:name, :any, default: nil)
  attr(:value, :any, default: nil)
  attr(:type, :string, default: "text", values: @input_types)
  attr(:checked, :boolean, required: false)
  attr(:checked_value, :any, default: true)
  attr(:hidden_input, :boolean, default: true)
  attr(:unchecked_value, :any, default: false)
  attr(:multiple, :boolean, default: false)
  attr(:rest, :global)

  def input(assigns) do
    assigns
    |> update(:id, &(&1.id || &1.name))
    |> update(:name, &(&1.multiple && "#{&1.name}[]"))
    |> update(:value, &Phoenix.HTML.Form.normalize_value("checkbox", &1.value))
    |> render_input()
  end

  attr(:id, :any, default: nil)
  attr(:name, :any, default: nil)
  attr(:value, :any, default: nil)
  attr(:multiple, :boolean, default: false)
  attr(:rest, :global)

  def textarea(assigns) do
    assigns =
      assigns
      |> update(:id, &(&1.id || &1.name))
      |> update(:name, &(&1.multiple && "#{&1.name}[]"))
      |> update(:value, &Phoenix.HTML.Form.normalize_value("checkbox", &1.value))

    ~H"""
    <textarea id={@id} name={@name} {@rest}><%= @value %></textarea>
    """
  end

  attr(:id, :any, default: nil)
  attr(:name, :any, default: nil)
  attr(:value, :any, default: nil)
  attr(:options, :list, default: [])
  attr(:prompt, :string, default: nil)
  attr(:multiple, :boolean, default: false)
  attr(:rest, :global)

  def select(assigns) do
    assigns =
      assigns
      |> update(:id, &(&1.id || &1.name))
      |> update(:name, &(&1.multiple && "#{&1.name}[]"))
      |> update(:value, &Phoenix.HTML.Form.normalize_value("checkbox", &1.value))

    ~H"""
    <select id={@id} name={@name} multiple={@multiple} {@rest}>
      <option :if={@prompt} value=""><%= @prompt %></option>
      <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
    </select>
    """
  end

  attr :id, :string, required: true
  attr :target, :string, default: "body"
  attr :update, :string, values: ~w(prepend append origin), default: "origin"
  attr :destroy_delay, :integer, default: 500
  attr :rest, :global
  slot :inner_block, required: true

  def portal(assigns) do
    ~H"""
    <template
      id={@id}
      phx-hook="Swish.Portal"
      data-target={@target}
      data-update={@update}
      data-destroy-delay={@destroy_delay}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </template>
    """
  end

  defp render_input(%{type: "checkbox"} = assigns) do
    ~H"""
    <input :if={@hidden_input} type="hidden" name={@name} value={@unchecked_value} />
    <input type="checkbox" id={@id} name={@name} value={@checked_value} checked={@value} {@rest} />
    """
  end

  defp render_input(assigns) do
    ~H"""
    <input type={@type} id={@id} name={@name} value={@value} {@rest} />
    """
  end
end
