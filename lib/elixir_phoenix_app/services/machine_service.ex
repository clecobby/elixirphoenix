defmodule ElixirPhoenixApp.MachineService do
  @api_hostname System.get_env("FLY_API_HOSTNAME") || "https://api.machines.dev"

  def get_machine_info do
    case System.get_env("FLY_MACHINE_ID") do
      nil ->
        {:error, :missing_env}

      machine_id ->
        {:ok,
         %{
           id: machine_id,
           name: System.get_env("FLY_APP_NAME") || "unavailable",
           image: System.get_env("FLY_IMAGE_REF") || "unavailable",
           created_at: fetch_created_at(machine_id),
           region: System.get_env("FLY_REGION") || "unavailable",
           private_ip: System.get_env("FLY_PRIVATE_IP") || "unavailable",
           state: "started"
         }}
    end
  end

  defp fetch_created_at(machine_id) do
    token = System.get_env("FLY_API_TOKEN")
    app_name = System.get_env("FLY_APP_NAME")

    IO.inspect(token != nil, label: "FLY_API_TOKEN exists")
    IO.inspect(app_name, label: "FLY_APP_NAME")
    IO.inspect(machine_id, label: "FLY_MACHINE_ID")

    with true <- not is_nil(token) and not is_nil(app_name),
         url = "#{@api_hostname}/v1/apps/#{app_name}/machines/#{machine_id}",
         _ = IO.inspect(url, label: "Fly API URL"),
         {:ok, %{status: status, body: body}} <-
           Req.get(url,
             headers: [{"authorization", "Bearer #{token}"}],
             receive_timeout: 3000
           ) do
      IO.inspect(status, label: "Fly API status")
      IO.inspect(body, label: "Fly API body")

      body["created_at"] || "unavailable"
    else
      error ->
        IO.inspect(error, label: "Fetch created_at failed")
        "unavailable"
    end
  end
end