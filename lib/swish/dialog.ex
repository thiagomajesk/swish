defmodule Swish.Dialog do
  @type t :: %Swish.Dialog{}

  @enforce_keys [:id, :teleport_id]
  defstruct [:id, :teleport_id]
end
