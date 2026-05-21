defmodule ElixirPhoenixAppWeb.HelloController do
  use Plug.Builder

  plug :dispatch

  def dispatch(conn, _opts) do
    case {conn.method, conn.request_path} do
      {"GET", "/"} -> handle_index(conn)
      {"GET", "/hello"} -> handle_hello(conn)
      {"GET", "/hello/" <> name} -> handle_hello_name(conn, name)
      _ -> not_found(conn)
    end
  end

  defp handle_index(conn) do
    body = Jason.encode!(%{
      message: "Welcome to Elixir Phoenix App",
      routes: ["/", "/hello", "/hello/:name"]
    })

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, body)
  end

  defp handle_hello(conn) do
    body = Jason.encode!(%{
      message: "Hello, World!",
      framework: "Elixir / Phoenix",
      status: "ok"
    })

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, body)
  end

  defp handle_hello_name(conn, name) do
    body = Jason.encode!(%{
      message: "Hello, #{name}!",
      framework: "Elixir / Phoenix",
      status: "ok"
    })

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, body)
  end

  defp not_found(conn) do
    body = Jason.encode!(%{error: "Not Found"})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, body)
  end
end
