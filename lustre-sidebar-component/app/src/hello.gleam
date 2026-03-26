import lustre/attribute.{class, type_, value}
import lustre/effect
import lustre/element/html.{div, h1, input, text}
import lustre/event.{on_input}

pub type Model {
  Model(name: String)
}

pub type Msg {
  ChangedName(name: String)
}

pub fn init() {
  Model("Stranger")
}

pub fn update(_: Model, msg: Msg) {
  #(Model(msg.name), effect.none())
}

pub fn view(model: Model) {
  div([class("flex flex-col gap-2 m-8")], [
    input([value(model.name), on_input(ChangedName), type_("text")]),
    h1([], [text("Hello " <> model.name)]),
  ])
}
