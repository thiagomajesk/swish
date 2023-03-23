# Swish

Swish is a UI toolkit for busy developers that provides a set unstyled component primitives, also know as "headless components", that you can to speed up your development workflow.

# The project

Phoenix 1.7 introduces a set of pre-generated core components which brings some flexibility. However, we've found that the work necessary to maintain those components in each project your work on is a little taxing for most developers. 

This library aims to reduce the amount of work necessary to maintain and reuse components by providing the expected behaviors through a terse API that you can use to build, customize and style your own components.

  
### Goals

- ✅ Provide a API somewhat compatible with the existing Phoenix.HTML helpers
- ✅ Provide set of components with built-in behaviors that you can style to create complete UIs on your own
- ✅ Provide a bare minimum degree of accessibility that you are most likely not going to implement by yourself 
- ✅ Allow the customization of component behaviors through a easy-to-use and well documented API 

Before using this library, it's important to understand that there are many different chalenges regarding UI design and this library is not meant to solve all of them. So, it's essential to identify your app's specific needs and if this library falls short on meeting them, don't worry. You can create the necessary abstractions when the time comes, and we're confident that by then, you'll have the experience and inspiration to do so with our source code as a helpful reference.

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

If you are using a different building mechanism than the default esbuild configuration...
Add the following line to your application's `package.json` to make the js dependency available:

```json
"dependencies": {
  "swish": "file:../deps/swish"
}
```

Add the Swish hooks to your application's `app.js`

```js
import SwishHooks from "swish";
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: { ...SwishHooks }})
```
