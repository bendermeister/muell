import counter
import gleam/result
import hello
import lustre
import lustre/attribute.{class, href}
import lustre/effect
import lustre/element
import lustre/element/html.{a, div, text}
import modem
import route
import sidebar

pub type Page {
  Hello(hello.Model)
  Counter(counter.Model)
  None
}

pub type Msg {
  ChangedPage(route: route.Route)
  UpdateCounter(counter.Msg)
  UpdateHello(hello.Msg)
}

pub type Model {
  Model(page: Page)
}

fn init(_) {
  let route =
    modem.initial_uri()
    |> result.map(route.from_uri)
    |> result.unwrap(route.Home)

  let page = case route {
    route.Home -> None
    route.Counter -> Counter(counter.init())
    route.Hello -> Hello(hello.init())
  }

  let model = Model(page:)

  let effect =
    modem.init(fn(uri) {
      uri
      |> route.from_uri
      |> ChangedPage
    })

  #(model, effect)
}

fn view(model: Model) {
  sidebar.element([], [div([class("w-full h-full bg-red-200")], [])])
}

fn view_none() {
  div([class("m-16 p-2 border w-fit flex flex-col gap-2")], [
    a([href("/counter")], [text("counter")]),
    a([href("/hello")], [text("hello")]),
  ])
}

fn update(model: Model, msg: Msg) -> #(Model, effect.Effect(Msg)) {
  case msg {
    ChangedPage(route:) -> {
      let page = case route {
        route.Home -> None
        route.Counter -> counter.init() |> Counter
        route.Hello -> hello.init() |> Hello
      }
      let model = Model(page:)
      #(model, effect.none())
    }

    UpdateCounter(msg) ->
      case model.page {
        Counter(page) -> {
          let #(page, effect) = counter.update(page, msg)
          let page = Counter(page)
          let model = Model(page:)
          #(model, effect)
        }
        _ -> #(model, effect.none())
      }
    UpdateHello(msg) ->
      case model.page {
        Hello(page) -> {
          let #(page, effect) = hello.update(page, msg)
          let page = Hello(page)
          let model = Model(page:)
          #(model, effect)
        }
        _ -> #(model, effect.none())
      }
  }
}

pub fn main() {
  let assert Ok(_) = sidebar.register()
  let assert Ok(_) =
    lustre.application(init, update, view)
    |> lustre.start("#app", Nil)
}
