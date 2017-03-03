# Paper

[![Build Status](https://travis-ci.org/nullobject/paper.svg?branch=master)](https://travis-ci.org/nullobject/paper)

A [page object](https://martinfowler.com/bliki/PageObject.html) library for writing cleaner acceptance tests with [Capybara](https://github.com/teamcapybara/capybara).

## Examples

```html
<header>
  <h1>Page Title</h1>
</header>
<nav>
  <a href="#">foo</a>
  <a href="#">bar</a>
  <a href="#" class="selected">baz</a>
</nav>
<article>
  lorem ipsum
</article>
```

We can define a `HomePage` class to semantically wrap the above content.

```ruby
class HomePage < Paper::Page
  component :header, Header, "header"
  component :nav, Nav, "nav"
  element :article, "article"

  def page
    "/"
  end
end
```

The `Header` class wraps the header component.
```ruby
class Header < Paper::Component
  element :title, "h1"
end
```

The `Nav` class wraps the navigation component.

```ruby
class Nav < Paper::Component
  components :items, NavItem, "a"
end
```

The `NavItem` class wraps a single navigation item.

```ruby
class NavItem < Paper::Component
  def selected?
    @node[:class].include?("selected")
  end
end
```

We can then make assertions with these page objects.

```ruby
feature "Home page" do
  let(:home_page) { HomePage.new }

  scenario "A user visits the home page" do
    home_page.visit
    expect(home_page).to be_current

    expect(home_page.header.title).to be("Page Title")

    expect(home_page.nav.items.count).to be(3)
    expect(home_page.nav.items[0].text).to eq("foo")
    expect(home_page.nav.items[1].text).to eq("bar")
    expect(home_page.nav.items[2].text).to eq("baz")
    expect(home_page.nav.items[2]).to be_selected

    expect(home_page.article.text).to eq("lorem ipsum")
  end
end
```
