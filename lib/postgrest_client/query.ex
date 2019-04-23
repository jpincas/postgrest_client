defmodule PostgrestClient.Query do
  alias __MODULE__
  alias PostgrestClient.Params
  alias PostgrestClient.Filter

  defstruct from: nil,
            select: [],
            filters: [],
            error: ""

  def from(table) do
    %Query{from: table}
  end

  def from(%Query{} = query, table) do
    %{query | from: table}
  end

  def select(%Query{} = query, fields) do
    %{query | select: fields}
  end

  def where(%Query{filters: filters} = query, field, operator, value) do
    if Filter.valid_operator?(operator) do
      %{query | filters: filters ++ [%Filter{field: field, operator: operator, value: value}]}
    else
      %{query | error: "'#{operator}' is an invalid operator!"}
    end
  end

  def to_string(%Query{} = query, root) do
    "http://#{root}/#{query.from}" <> Params.to_string(query)
  end
end
