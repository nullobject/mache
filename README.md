# Mâché

[![Build Status](https://travis-ci.org/nullobject/mache.svg?branch=master)](https://travis-ci.org/nullobject/mache)

Mâché (pronounced "mash-ay") is a tool that helps you to write cleaner and more
expressive acceptance tests for your Ruby web applications using page objects.

## Table of contents

* [Mâché](#mâché)
  * [Table of contents](#table-of-contents)
  * [What is a page object?](#what-is-a-page-object)
  * [Getting started](#getting-started)
    * [Elements](#elements)
    * [Components](#components)
    * [Helpers](#helpers)
  * [Example](#example)
  * [API documentation](#api-documentation)
  * [Contributing](#contributing)
  * [License](#license)

## What is a page object?

A [page object](https://martinfowler.com/bliki/PageObject.html) is a data
structure that provides an interface to your web application for the purposes
of test automation. For example, it could represent a single HTML page, or
perhaps even a fragment of HTML on a page.

From [Martin Fowler](https://martinfowler.com/bliki/PageObject.html):

> A page object wraps an HTML page, or fragment, with an application-specific
> API, allowing you to manipulate page elements without digging around in the
> HTML.

[Capybara](https://github.com/teamcapybara/capybara) can get us part of the way
there. It allows us to work with an API rather than manipulating the HTML
directly, but what it provides isn't an *application specific* API. It gives us
low-level API methods like `find`, `fill_in`, and `click_button`, but it
doesn't provide us with high-level methods to do things like "sign in to the
app" or "click the Dashboard item in the navigation bar".

This is where page objects come in. Using Mâché we can for instance define a
page object class called `SignInPage` and use it any time we want to automate
authenticating with our app. It could handle visiting the sign in page,
entering the user's credentials, and clicking the "Sign in" button.

## Getting started

Let's dive straight in and take a look at an example. Consider the following
HTML fragment for the welcome page in our app:

```html
<html>
  <body>
    <header>
      <h1>Welcome</h1>
      <div id="flash" class="notice">lorem ipsum</div>
    </header>
    <nav>
      <ul>
        <li><a href="/foo" class="selected">foo</a></li>
        <li><a href="/bar">bar</a></li>
        <li><a href="/baz">baz</a></li>
      </ul>
    </nav>
    <main>
      lorem ipsum
    </main>
  </body>
</html>
```

To define a `WelcomePage` page object class to wrap this HTML page, we extend
the `Mache::Page` class. The only method our class needs to provide is `path`,
this tells Mâché where to go when we want to visit the page:

```ruby
require "mache"

class WelcomePage < Mache::Page
  def path
    "/welcome"
  end
end
```

We can visit our welcome page using our page object:

```ruby
page = WelcomePage.visit
page.current? # true
```

Mâché also handily exposes the Capybara API on our page object:

```ruby
page.find("main").text # "lorem ipsum"
```

### Elements

To make our page object more useful, we can define an element on our page
object class using the `element` macro. An element is simply an HTML element
that we expect to find on the page using a CSS selector.

Let's define a `main` element to represent the main section of our HTML page:

```ruby
require "mache"

class WelcomePage < Mache::Page
  element :main, "main"

  def path
    "/welcome"
  end
end
```

We can query the `main` element as an attribute of our page object:

```ruby
page.main.text # "lorem ipsum"
```

### Components

For elements that can be shared across any number of page object classes it may
be useful to define a reusable component by extending the `Mache::Node` class.
A component can contain any number of elements (or even other components).

Let's define a `Header` component to represent the header of our HTML page:

```ruby
require "mache"

class Header < Mache::Node
  element :title, "h1"
end
```

We can mount the `Header` component in our page object class at a given CSS
selector using the `component` macro:

```ruby
require "mache"

class WelcomePage < Mache::Page
  component :header, Header, "header"
  element :main, "main"

  def path
    "/welcome"
  end
end
```

Querying a component of our page object is much the same as with an element:

```ruby
page.header.title.text # "Welcome"
```

### Helpers

Mâché provides helpers for testing Rails apps.

#### Flash

The `Flash` helper provides methods for testing flash messages. First define a
flash in your page object class:

```ruby
require "mache"
require "mache/helpers/rails"

class WelcomePage < Mache::Page
  include Mache::Helpers::Rails::Flash

  flash "#flash"
end
```

Then you can query the flash on your page object:

```ruby
page.has_message?(:success, "lorem ipsum")
page.has_message?(:success, /lorem ipsum/)
```

There are even convenience matchers for the common types of flash messages:

```ruby
page.has_success_message?("lorem ipsum")
page.has_notice_message?("lorem ipsum")
page.has_alert_message?("lorem ipsum")
page.has_error_message?("lorem ipsum")
```

#### Routes

The `Routes` helper mixes the Rails URL helpers into your page object class.
This allows you to use the `*_path` and `*_url` methods as you normally would
in your Rails.

```ruby
require "mache"
require "mache/helpers/rails"

class WelcomePage < Mache::Page
  include Mache::Helpers::Rails::Routes

  def path
    welcome_path
  end
end
```

## Example

Let's look at an example of an acceptance test for our `WelcomePage`. Note that
the `Header`, `NavItem`, and `Nav` components can be reused in any other page
object classes we may define later for our web application.

```ruby
require "mache"
require "mache/helpers/rails"

class Header < Mache::Node
  element :title, "h1"
end

class NavItem < Mache::Node
  def selected?
    node[:class].include?("selected")
  end
end

class Nav < Mache::Node
  components :items, NavItem, "a"

  def selected_item
    items.find(&:selected?)
  end
end

class WelcomePage < Mache::Page
  include Mache::Helpers::Rails::Flash
  include Mache::Helpers::Rails::Routes

  component :header, Header, "header"
  component :nav, Nav, "nav"
  element :main, "main"
  flash "#flash"

  def path
    welcome_path
  end
end

feature "Welcome page" do
  let(:home_page) { WelcomePage.visit }

  scenario "A user visits the welcome page" do
    expect(home_page).to be_current

    # header
    expect(home_page).to have_header
    expect(home_page.header.title).to eq("Welcome")

    # nav
    expect(home_page).to have_nav
    expect(home_page.nav).to have_items
    expect(home_page.nav.items.count).to be(3)
    expect(home_page.nav.items[0].text).to eq("foo")
    expect(home_page.nav.items[1].text).to eq("bar")
    expect(home_page.nav.items[2].text).to eq("baz")
    expect(home_page.nav.selected_item).to eq("foo")

    # main
    expect(home_page.main.text).to eq("lorem ipsum")

    # flash
    expect(home_page).to have_flash
    expect(home_page).to have_notice_message("lorem ipsum")
  end
end
```

## API documentation

Read the [API documentation](http://www.rubydoc.info/gems/mache) on RubyDoc.

## License

Mâché is licensed under the [MIT License](/LICENSE.md).
