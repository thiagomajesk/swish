# Swish

Swish is a UI toolkit for busy developers and a "no frills" replacement for the standard Phoenix 1.7 core components.
This project aims to provide unstyled component primitives that you can use directly to speed up your development workflow.

# Goals of this project

Phoenix 1.7 introduces a set of pre-generated core components in your project which brings more flexibility but puts the burden of maintenance on the developer. This lib aims to reduce the amount of work necessary to use and customize components while supporting similar helpers like the (legacy!?) Phoenix.HTML lib.  

- ✅ Provide a terse API compatible with the existing Phoenix.HTML helpers (with and without forms)
- ✅ Provide base components that work out of the box and also allow easy reuse and customization
- ❌ Provide a full component set that follows a strict design system¹

> It's important to notice that there's many different needs regarding UI markup and this library is not meant to solve them all. As soon as you identify that your app is growing beyond what we can provide out of the box, we recommend that you create your own implementations. Hopefully by then, you will have the time and experience necessary to do, as well as the source code of this library that you can use as inspiration.

> ¹If this is what you want that take a look at [Surface UI](https://surface-ui.org/), [Primer Live](https://github.com/ArthurClemens/primer_live) or [Sprout UI](https://github.com/TunkShif/sprout_ui)

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
