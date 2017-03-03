# Paper

[![Build Status](https://travis-ci.org/nullobject/paper.svg?branch=master)](https://travis-ci.org/nullobject/paper)

A [page object](https://martinfowler.com/bliki/PageObject.html) library for writing cleaner acceptance tests with [Capybara](https://github.com/teamcapybara/capybara).

## Getting started

Consider the following HTML snippet:

```html
<html>
  <body>
    <header>
      <h1>Welcome</h1>
    </header>
    <nav>
      <a href="#" class="selected">foo</a>
      <a href="#">bar</a>
      <a href="#">baz</a>
    </nav>
    <main>
      lorem ipsum
    </main>
  </body>
</html>
```

To define a page object class to wrap this HTML snippet, we extend the
`Paper::Page` class. The only method our class needs to provide is `path`, this
tells Paper where to go when we want to visit the page.

```ruby
class WelcomePage < Paper::Page
  def path
    "/welcome"
  end
end
```

This is how we visit our page object:

```ruby
page = WelcomePage.visit
page.current? # true
```

Any Capybara API methods will be forwarded to the underlying node:

```ruby
page.find("body > main").text # "lorem ipsum"
```

### Elements

To make our page object more useful, we can define an element on our page
object class using the `element` macro. An element is simply a HTML element
that we expect to find on the page using a CSS selector.

Let's define a `main` element:

```ruby
class WelcomePage < Paper::Page
  element :main, "body > main"

  def path
    "/welcome"
  end
end
```

Now we can query the element on our page object:

```ruby
page.has_main? # true
page.main.visible? # true
page.main.text # "lorem ipsum"
```

### Components

For elements that can be shared across an number of page object classes, it may
be useful to define a reusable component by extending the `Paper::Component`
class. A component class can contain any number of elements or other
components:

```ruby
class Header < Paper::Component
  element :title, "h1"
end
```

Our page object class can mount our component at a given CSS selector using the
`component` macro:

```ruby
class WelcomePage < Paper::Page
  component :header, Header, "header"
  element :main, "body > main"

  def path
    "/welcome"
  end
end
```

Querying a component on our page object is much the same as an element:

```ruby
page.has_header? # true
page.header.visible? # true
page.header.title.text # "Welcome"
```

## Example

Let's look at a more complete example for our `WelcomePage`:

```ruby
class Header < Paper::Component
  element :title, "h1"
end

class NavItem < Paper::Component
  def selected?
    node[:class].include?("selected")
  end
end

class Nav < Paper::Component
  components :items, NavItem, "a"
end

class WelcomePage < Paper::Page
  component :header, Header, "header"
  component :nav, Nav, "nav"
  element :main, "main"

  def path
    "/welcome"
  end
end
```

We can use our page objects to write expressive tests:

```ruby
feature "Home page" do
  let(:home_page) { WelcomePage.visit }

  scenario "A user visits the home page" do
    expect(home_page).to be_current

    expect(home_page).to have_header
    expect(home_page.header.title).to eq("Welcome")

    expect(home_page).to have_nav
    expect(home_page.nav).to have_items
    expect(home_page.nav.items.count).to be(3)

    expect(home_page.nav.items[0].text).to eq("foo")
    expect(home_page.nav.items[1].text).to eq("bar")
    expect(home_page.nav.items[2].text).to eq("baz")

    expect(home_page.nav.items[0]).to be_selected

    expect(home_page.main.text).to eq("lorem ipsum")
  end
end
```
