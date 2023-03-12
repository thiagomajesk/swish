defmodule Swish.Form do
  use Phoenix.Component

  @doc """
  Renders a form component.

  ## Examples

  #### Simple form control

  ```heex
  <Swish.Form.root for={@changeset}>
    <Swish.Form.group field={f[:email]} type="text" label="Email">
      <Swish.Form.message :let={errors} for={msg <- errors}>
        <p><%= msg %></p>
      </Swish.Form.message>
    </Swish.Form.group>

    <Swish.Form.group field={f[:password]} type="password" label="Password">
      <Swish.Form.message :let={errors} for={msg <- errors}>
        <p><%= msg %></p>
      </Swish.Form.message>
    </Swish.Form.group>
  </Swish.Form.root>
  ```
  """
  attr(:for, :any, required: true)
  attr(:as, :any, default: nil)
  slot(:inner_block, required: true)
  attr(:rest, :global)

  def root(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <%= render_slot(@inner_block, f) %>
    </.form>
    """
  end

  @doc """
  Renders a form control component.

  ## Examples

  #### Simple form control

  ```heex
  <Swish.Form.control field={f[:name]} type="text" />
  <Swish.Form.control field={f[:name]} type="password" />
  <Swish.Form.control field={f[:name]} type="textarea" />
  <Swish.Form.control field={f[:name]} type="select" />
  ```
  """

  attr(:field, Phoenix.HTML.FormField)
  attr(:type, :string, default: "text")
  attr(:rest, :global)

  def control(%{field: %Phoenix.HTML.FormField{}} = assigns) do
    assigns
    |> assign_new(:id, & &1.field.id)
    |> assign_new(:name, & &1.field.name)
    |> assign_new(:value, & &1.field.value)
    |> render_control()
  end

  @doc """
  Renders a label component.

  ## Examples

  #### Simple label

  ```heex
  <Swish.Form.label field={f[:name]}>
    Name
  </Swish.Form.label>
  ```
  """

  attr(:label, :string)
  attr(:field, Phoenix.HTML.FormField)
  attr(:rest, :global)

  def label(%{field: %Phoenix.HTML.FormField{}} = assigns) do
    assigns =
      assigns
      |> assign_new(:for, & &1.field.id)
      |> assign_new(:label, &Phoenix.Naming.humanize(&1.field.name))

    ~H"""
    <Swish.Tag.label for={@for} {@rest}>
      <%= @label %>
    </Swish.Tag.label>
    """
  end

  @doc """
  Renders a message component.

  ## Examples

  #### Simple message

  ```heex
  <Swish.Form.message field={f[:name]}>
    Name is a required field.
  </Swish.Form.message>
  ```

  #### Custom tag

  ```heex
  <Swish.Form.message field={f[:name]} tag="small">
    Name is a required field.
  </Swish.Form.message>
  ```
  """

  attr(:tag, :any, default: "p")
  attr(:field, Phoenix.HTML.FormField)
  attr(:rest, :global)

  def message(%{field: %Phoenix.HTML.FormField{}} = assigns) do
    assigns = assign_new(assigns, :errors, & &1.field.errors)

    ~H"""
    <.dynamic_tag name={@tag} {@rest}>
      <%= render_slot(@inner_block, @errors) %>
    </.dynamic_tag>
    """
  end

  attr(:id, :any, default: nil)
  attr(:name, :any, default: nil)
  attr(:label, :any, default: true)
  attr(:value, :any, default: nil)
  attr(:field, Phoenix.HTML.FormField)
  attr(:rest, :global)

  @doc """
  Renders a form group component.

  ## Examples

  #### Simple form group

  ```heex
  <Swish.Form.group>
    <Swish.Form.control type="text" field={f[:name]} />
  </Swish.Form.group>
  ```

  #### Custom label

  ```heex
  <Swish.Form.group label="Enter your first name">
    <Swish.Form.control type="text" field={f[:name]} />
  </Swish.Form.group>
  ```

   #### Hidden label

  ```heex
  <Swish.Form.group label={false}>
    <Swish.Form.control type="text" field={f[:name]} />
  </Swish.Form.group>

  """

  def group(%{field: %Phoenix.HTML.FormField{}} = assigns) do
    assigns
    |> assign_new(:id, & &1.field.id)
    |> assign_new(:name, & &1.field.name)
    |> assign_new(:label, &Phoenix.Naming.humanize(&1.field.name))
    |> assign_new(:value, & &1.field.value)
    |> assign_new(:errors, & &1.field.errors)
    |> render_group()
  end

  defp render_control(%{type: "textarea"} = assigns) do
    ~H"""
    <Swish.Tag.textarea id={@id} name={@name} value={@value} {@rest} />
    """
  end

  defp render_control(%{type: "select"} = assigns) do
    ~H"""
    <Swish.Tag.select id={@id} name={@name} value={@value} {@rest} />
    """
  end

  defp render_control(assigns) do
    ~H"""
    <Swish.Tag.input type={@type} id={@id} name={@name} value={@value} {@rest} />
    """
  end

  defp render_group(%{label: false} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp render_group(%{label: label} = assigns) when is_binary(label) do
    ~H"""
    <div phx-feedback-for={@name} {@rest}>
      <Swish.Form.label field={@field} />
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
