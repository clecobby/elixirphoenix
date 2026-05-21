defmodule ElixirPhoenixAppWeb.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_html(conn, 200, machine_html())
  end

  get "/hello" do
    send_html(conn, 200, machine_html())
  end

  get "/hello/:_name" do
    send_html(conn, 200, machine_html())
  end

  match _ do
    send_html(conn, 404, "<p>Route not found</p>")
  end

  defp machine_html do
    case ElixirPhoenixApp.MachineService.get_machine_info() do
      {:ok, m} ->
        """
        <dl>
          <dt>Machine ID</dt>
          <dd>#{m.id}</dd>

          <dt>Machine Name</dt>
          <dd>#{m.name}</dd>

          <dt>Image</dt>
          <dd>#{m.image}</dd>

          <dt>Created At</dt>
          <dd>#{m.created_at}</dd>

          <dt>Region</dt>
          <dd>#{m.region}</dd>

          <dt>Private IP</dt>
          <dd>#{m.private_ip}</dd>

          <dt>State</dt>
          <dd>#{m.state}</dd>
        </dl>
        """

      _ ->
        "<dl><dt>Status</dt><dd>Machine info unavailable — FLY_API_TOKEN, FLY_APP_NAME, FLY_MACHINE_ID not set</dd></dl>"
    end
  end

  defp send_html(conn, status, body) do
    conn
    |> Plug.Conn.put_resp_content_type("text/html")
    |> Plug.Conn.send_resp(status, body)
  end
end
