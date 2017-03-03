require "rack/file"
require "spec_helper"

class Label < Paper::Component
  def required?
    @node[:class].include?("required")
  end
end

class Field < Paper::Component
  component :label, Label, "label"
  element :input, "input"
end

class Form < Paper::Component
  components :fields, Field, "div"
  element :button, "button"
end

class Header < Paper::Component
  element :title, "h1"
end

class MyPage < Paper::Page
  component :header, Header, "header"
  component :form, Form, "form"

  def path
    "/sign_in.html"
  end

  def sign_in(username, password)
    fill_in "Username", with: username
    fill_in "Password", with: password
    form.button.click
  end
end

describe MyPage do
  before do
    Capybara.app = Rack::File.new(File.expand_path("../../fixtures", __FILE__))
  end

  subject(:page) { MyPage.visit }

  it "has a header" do
    expect(page).to have_header
    expect(page.header.title.text).to eq("Sign in")
  end

  it "has a form" do
    expect(page.form.fields[0].label.text).to eq("Username")
    expect(page.form.fields[0].label).to be_required
    expect(page.form.fields[0].input.value).to be_nil

    expect(page.form.fields[1].label.text).to eq("Password")
    expect(page.form.fields[1].input.value).to be_nil

    expect(page.form).to have_button
    expect(page.form.button.text).to eq("Sign in")
  end

  it "can sign in" do
    page.sign_in("jane", "secret")
  end
end
