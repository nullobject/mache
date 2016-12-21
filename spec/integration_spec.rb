require "spec_helper"

class Field < Paper::Component
  element :label, "label"
  element :input, "input"
end

class Header < Paper::Component
  element :title, "h1"
end

class MyPage < Paper::Page
  component :header, Header, "header"
  components :fields, Field, "form > div"
  element :button, "button"
end

describe MyPage do
  let(:node) do
    Capybara.string <<-HTML
      <header>
        <h1>People</h1>
      </header>
      <form>
        <div>
          <label>Name</label>
          <input type="text" name="name" value="Jane Citizen">
        </div>
        <div>
          <label>Phone</label>
          <input type="text" name="phone" value="12345678">
        </div>
        <button type="submit">Save</button>
      </form>
    HTML
  end

  subject(:page) { MyPage.new(node: node) }

  it "handles elements" do
    expect(page.button.text).to eq("Save")
  end

  it "handles a single nested component" do
    expect(page.header.title.text).to eq("People")
  end

  it "handles multiple nested components" do
    expect(page.fields[0].label.text).to eq("Name")
    expect(page.fields[0].input.value).to eq("Jane Citizen")

    expect(page.fields[1].label.text).to eq("Phone")
    expect(page.fields[1].input.value).to eq("12345678")
  end
end
