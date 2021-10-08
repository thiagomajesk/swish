# Swish

Swish is a UI toolkit for busy developers and a "no frills" replacement for the standard Phoenix 1.7 core components.

# Goals of this project

Phoenix 1.7 introduces a set of pre-generated core components in your project which brings more flexibility but puts the burden of maintenance on the developer. This lib aims to reduce the amount of work necessary to use and customize components while supporting similar helpers like the (legacy!?) Phoenix.HTML lib.  

- ✅ Provide a terse API compatible with the existing Phoenix.HTML helpers (with and without forms)
- ✅ Provide base components that work out of the box and also allow easy customization
- ❌ Provide a full component set that follows a strict design system¹

> ¹If this is what you want that take a look at [Surface UI](https://surface-ui.org/), [DaisyUI](https://daisyui.com/), [Primer Live](https://github.com/ArthurClemens/primer_live) or [Sprout UI](https://github.com/TunkShif/sprout_ui)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `swish` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:swish, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/swish>.
