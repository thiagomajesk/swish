defmodule Swish.Dialog.Transitions do
  @moduledoc """
  Describes the available transitions for a dialog.
  """

  defstruct [:show_content, :hide_content, :show_backdrop, :hide_backdrop]
end
