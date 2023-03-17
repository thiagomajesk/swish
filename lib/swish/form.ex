defmodule Swish.Form do
  use Phoenix.Component

  @doc """
  Renders a form component.

  ## Examples

  #### Simple form control

  ```heex
  <Swish.Form.root for={@changeset} :let={f}>
    <Swish.Form.group field={f[:email]}>
      <Swish.Form.control field={f[:email]} as="text" />
      <Swish.Form.label field={f[:email]} />
      <Swish.Form.message field={f[:email]} :let={errors}>
        <span :for={error <- errors}><%= error %></span>
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
  Renders a form group component.

  ## Examples

  #### Simple form group

  ```heex
  <Swish.Form.group field={f[:name]}>
    <Swish.Form.control field={f[:name]} as="text" />
  </Swish.Form.group>
  ```
  """
  attr(:field, Phoenix.HTML.FormField, required: true)
  attr(:name, :string, required: false)
  slot(:inner_block, required: true)
  attr(:rest, :global)

  def group(assigns) do
    assigns = assign_new(assigns, :name, & &1.field.name)

    ~H"""
    <div phx-feedback-for={@name} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a form control component.

  ## Examples

  #### Simple form control

  ```heex
  <Swish.Form.control field={f[:name]} as="text" />
  <Swish.Form.control field={f[:name]} as="password" />
  <Swish.Form.control field={f[:name]} as="textarea" />
  <Swish.Form.control field={f[:name]} as="select" />
  ```
  """

  attr(:field, Phoenix.HTML.FormField, required: true)
  attr(:as, :string, default: "text")
  attr(:rest, :global)

  def control(assigns) do
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
  <Swish.Form.label field={f[:name]} />
  ```

  #### Custom content

  ```heex
  <Swish.Form.label field={f[:name]}>
    Name
  </Swish.Form.label>
  ```
  """

  attr(:field, Phoenix.HTML.FormField, required: true)
  attr(:label, :string, required: false)
  slot(:inner_block, required: false)
  attr(:rest, :global)

  def label(assigns) do
    assigns =
      assigns
      |> assign_new(:for, & &1.field.id)
      |> assign_new(:label, &Phoenix.Naming.humanize(&1.field.name))

    ~H"""
    <Swish.Tag.label for={@for} {@rest}>
      <%= (@innner_block != [] && render_slot(@inner_block)) || @label %>
    </Swish.Tag.label>
    """
  end

  @doc """
  Renders a message component.

  ## Examples

  #### Simple message

  ```heex
  <Swish.Form.message :let={errors} field={f[:name]}>
    ...
  </Swish.Form.message>
  ```

  #### Custom tag

  ```heex
  <Swish.Form.message :let={errors} field={f[:name]} as="small">
    ...
  </Swish.Form.message>
  ```
  """

  attr(:field, Phoenix.HTML.FormField, required: true)
  attr(:as, :string, default: "p")
  slot(:inner_block, required: true)
  attr(:rest, :global)

  def message(assigns) do
    assigns = assign_new(assigns, :errors, &Enum.map(&1, translate_error(&1)))

    ~H"""
    <.dynamic_tag name={@as} {@rest}>
      <%= render_slot(@inner_block, @errors) %>
    </.dynamic_tag>
    """
  end

  defp render_control(%{as: "textarea"} = assigns) do
    ~H"""
    <Swish.Tag.textarea id={@id} name={@name} value={@value} {@rest} />
    """
  end

  defp render_control(%{as: "select"} = assigns) do
    ~H"""
    <Swish.Tag.select id={@id} name={@name} value={@value} {@rest} />
    """
  end

  defp render_control(assigns) do
    ~H"""
    <Swish.Tag.input type={@as} id={@id} name={@name} value={@value} {@rest} />
    """
  end

  def translate_error({msg, opts}) do
    module = Application.get_env(:swish, :gettext)

    case {module, opts[:count]} do
      {nil, _} -> msg
      {module, nil} -> Gettext.dgettext(module, "errors", msg, opts)
      {module, count} -> Gettext.dngettext(module, "errors", msg, msg, count, opts)
    end
  end
end
