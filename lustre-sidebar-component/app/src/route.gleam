import gleam/result
import gleam/uri

pub type Route {
  Home
  Counter
  Hello
}

pub fn from_string(s: String) -> Result(Route, Nil) {
  uri.parse(s)
  |> result.map(from_uri)
}

pub fn from_uri(uri: uri.Uri) {
  case uri.path_segments(uri.path) {
    [] -> Home
    ["counter"] -> Counter
    ["hello"] -> Hello
    _ -> Home
  }
}
