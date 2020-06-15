defmodule Swish.HTML.Adapters.Bootstrap do
  use Swish.HTML.Generator

  def build_alert(name, context, content, opts \\ []) do
    class_opts = Keyword.get(opts, :class, "")
    alert_class = String.trim_trailing("alert alert-#{context} #{class_opts}")
    alert_opts = [class: alert_class, role: "alert"]
    content_tag(name, content, Keyword.merge(opts, alert_opts))
  end

  def build_badge(name, context, content, opts \\ []) do
    case opts[:variation] do
      :pill -> build_badge_pill(name, context, content, Keyword.delete(opts, :variaton))
      _ -> build_badge_default(name, context, content, Keyword.delete(opts, :variaton))
    end
  end

  defp build_badge_default(name, context, content, opts) do
    class_opts = Keyword.get(opts, :class, "")
    badge_class = String.trim_trailing("badge badge-#{context} #{class_opts}")
    badge_opts = [class: badge_class]
    content_tag(name, content, Keyword.merge(opts, badge_opts))
  end

  defp build_badge_pill(name, context, content, opts) do
    class_opts = Keyword.get(opts, :class, "")
    badge_class = String.trim_trailing("badge badge-pill badge-#{context} #{class_opts}")
    badge_opts = [class: badge_class]
    content_tag(name, content, Keyword.merge(opts, badge_opts))
  end
end
