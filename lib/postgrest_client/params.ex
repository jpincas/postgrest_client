defmodule PostgrestClient.Params do
  alias PostgrestClient.Query
  alias PostgrestClient.Filter
  import PostgrestClient.Helpers

  def to_string(%Query{select: fields, filters: filters}) do
    ([select_fields_to_string(fields)] ++ Enum.map(filters, fn f -> Filter.to_string(f) end))
    |> Enum.filter(fn param -> not blank?(param) end)
    |> Enum.join("&")
    |> attach_params()
  end

  defp attach_params(params_string) do
    params_string |> if_not_blank(fn s -> "?#{s}" end)
  end

  defp select_fields_to_string(fields) do
    fields
    |> Enum.join(",")
    |> if_not_blank(fn s -> "select=#{s}" end)
  end
end
