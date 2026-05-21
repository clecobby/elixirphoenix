defmodule ElixirPhoenixApp.MachineService do
  def get_machine_info do
    token = System.get_env("FLY_API_TOKEN")
    app_name = System.get_env("FLY_APP_NAME")
    machine_id = System.get_env("FLY_MACHINE_ID")
    hostname = System.get_env("FLY_API_HOSTNAME") || "http://_api.internal:4280"

    with true <- not is_nil(token) and not is_nil(app_name) and not is_nil(machine_id),
         url = "#{hostname}/v1/apps/#{app_name}/machines/#{machine_id}",
         {:ok, %{status: 200, body: body}} <-
           Req.get(url, headers: [{"authorization", "Bearer #{token}"}]) do
      {:ok,
       %{
         id: body["id"],
         name: body["name"],
         image: get_in(body, ["config", "image"]),
         created_at: body["created_at"],
         region: body["region"],
         private_ip: body["private_ip"],
         state: body["state"]
       }}
    else
      false -> {:error, :missing_env}
      _ -> {:error, :fetch_failed}
    end
  end
end
