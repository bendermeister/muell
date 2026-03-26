import gleam/int
import gleam/pair
import lustre/attribute.{class}
import lustre/effect
import lustre/element/html.{button, div, text}
import lustre/event.{on_click}

pub type Model {
  Model(value: Int)
}

pub type Msg {
  Increment
  Decrement
}

pub fn update(model: Model, msg: Msg) {
  case msg {
    Increment ->
      Model(value: model.value + 1)
      |> pair.new(effect.none())
    Decrement ->
      Model(value: model.value - 1)
      |> pair.new(effect.none())
  }
}

pub fn init() {
  Model(0)
}

pub fn view(model: Model) {
  div([class("flex flex-col gap-2")], [
    button([on_click(Increment)], [text("+")]),
    text(int.to_string(model.value)),
    button([on_click(Decrement)], [text("-")]),
  ])
}
