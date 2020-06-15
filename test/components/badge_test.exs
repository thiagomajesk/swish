defmodule Swish.Components.BadgeTest do
  use ExUnit.Case

  import Phoenix.HTML, only: [safe_to_string: 1]

  import Swish.HTML.Components.Badge

  doctest Swish.HTML.Components.Badge

  describe "badges" do
    test "badge/2 do-block" do
      component = badge(:primary, do: "foo")
      result = safe_to_string(component)
      assert result == "<span class=\"badge badge-primary\">foo</span>"
    end

    test "badge/2" do
      component = badge(:primary, "foo")
      result = safe_to_string(component)
      assert result == "<span class=\"badge badge-primary\">foo</span>"
    end

    test "badge/3 do-block" do
      component = badge(:primary, [class: "bar"], do: "foo")
      result = safe_to_string(component)
      assert result == "<span class=\"badge badge-primary bar\">foo</span>"
    end

    test "badge/3" do
      component = badge(:primary, "foo", class: "bar")
      result = safe_to_string(component)
      assert result == "<span class=\"badge badge-primary bar\">foo</span>"
    end

    test "badge/4 do-block" do
      component = badge(:div, :primary, [class: "bar"], do: "foo")
      result = safe_to_string(component)
      assert result == "<div class=\"badge badge-primary bar\">foo</div>"
    end

    test "badge/4" do
      component = badge(:div, :primary, "foo", class: "bar")
      result = safe_to_string(component)
      assert result == "<div class=\"badge badge-primary bar\">foo</div>"
    end
  end
end
