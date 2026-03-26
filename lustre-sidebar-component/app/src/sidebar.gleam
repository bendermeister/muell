import gleam/pair
import lustre
import lustre/attribute.{class, href}
import lustre/component
import lustre/effect
import lustre/element
import lustre/element/html.{a, button, div, h1, text}
import lustre/event.{on_click}

type State {
  Open
  Closed
}

type Model {
  Model(state: State)
}

type Msg {
  UserClosedSidebar
  UserOpenedSidebar
}

fn view_sidebar(model: Model) {
  case model.state {
    Open -> view_sidebar_open()
    Closed -> view_sidebar_closed()
  }
}

fn view_sidebar_closed() {
  div([class("w-[3rem] h-full shadow flex flex-col p-2 gap-4")], [
    button([class("text-2xl"), on_click(UserOpenedSidebar)], [text(">")]),
    a([href("/counter"), class("hover:cursor-pointer")], [text("- C")]),
    a([href("/hello"), class("hover:cursor-pointer")], [text("- H")]),
  ])
}

fn view_sidebar_open() {
  div([class("w-[10rem] h-full shadow flex flex-col p-2")], [
    div([class("flex flex-row justify-between items-center gap-4")], [
      h1([], [text("open")]),
      button([on_click(UserClosedSidebar), class("text-2xl")], [text("<")]),
    ]),
    a([href("/counter"), class("hover:cursor-pointer")], [text("- Counter")]),
    a([href("/hello"), class("hover:cursor-pointer")], [text("- Hello")]),
  ])
}

fn view_header() {
  div(
    [
      class("w-screen h-[3rem]"),
      class("shadow"),
      class("flex flex-row justify-between items-center"),
      class("py-2 px-10"),
    ],
    [
      h1([class("text-2xl text-violet-400")], [text("sidebar poc")]),
      div([class("flex flex-row gap-2 justify-end items-center")], [
        a([], [text("about")]),
        a([], [text("login")]),
      ]),
    ],
  )
}

fn view(model) {
  div([class("w-screen h-screen flex flex-col")], [
    view_header(),
    div([class("flex-grow flex flex-row")], [
      view_sidebar(model),
      div([class("flex-grow p-4")], [component.default_slot([], [])]),
    ]),
  ])
}

fn update(_, msg) {
  case msg {
    UserClosedSidebar ->
      Model(state: Closed)
      |> pair.new(effect.none())
    UserOpenedSidebar ->
      Model(state: Open)
      |> pair.new(effect.none())
  }
}

fn init(_) {
  #(Model(state: Open), effect.none())
}

pub fn register() {
  lustre.component(init, update, view, [])
  |> lustre.register("my-sidebar")
}

pub fn element(attrs, children) {
  element.element("my-sidebar", attrs, children)
}
