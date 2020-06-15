defmodule Swish.Components.AlertTest do
  use ExUnit.Case

  import Phoenix.HTML, only: [safe_to_string: 1]

  import Swish.HTML.Components.Alert

  doctest Swish.HTML.Components.Alert

  describe "alerts" do
    test "alert/2 do-block" do
      component = alert(:primary, do: "foo")
      result = safe_to_string(component)
      assert result == "<div class=\"alert alert-primary\" role=\"alert\">foo</div>"
    end

    test "alert/2" do
      component = alert(:primary, "foo")
      result = safe_to_string(component)
      assert result == "<div class=\"alert alert-primary\" role=\"alert\">foo</div>"
    end

    test "alert/3 do-block" do
      component = alert(:primary, [class: "bar"], do: "foo")
      result = safe_to_string(component)
      assert result == "<div class=\"alert alert-primary bar\" role=\"alert\">foo</div>"
    end

    test "alert/3" do
      component = alert(:primary, "foo", class: "bar")
      result = safe_to_string(component)
      assert result == "<div class=\"alert alert-primary bar\" role=\"alert\">foo</div>"
    end

    test "alert/4 do-block" do
      component = alert(:p, :primary, [class: "bar"], do: "foo")
      result = safe_to_string(component)
      assert result == "<p class=\"alert alert-primary bar\" role=\"alert\">foo</p>"
    end

    test "alert/4" do
      component = alert(:p, :primary, "foo", class: "bar")
      result = safe_to_string(component)
      assert result == "<p class=\"alert alert-primary bar\" role=\"alert\">foo</p>"
    end
  end
end
