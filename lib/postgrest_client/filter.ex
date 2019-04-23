defmodule PostgrestClient.Filter do
  alias __MODULE__

  # See http://postgrest.org/en/v5.2/api.html
  @valid_operators [
    :eq,
    :gt,
    :gte,
    :lt,
    :lte,
    :neq,
    :like,
    :ilike,
    :in,
    :is,
    :fts,
    :plfts,
    :phfts,
    :cs,
    :cd,
    :ov,
    :sl,
    :sr,
    :nxr,
    :nxl,
    :adj
  ]

  defstruct field: "",
            operator: :is,
            value: ""

  def to_string(%Filter{field: field, operator: operator, value: value}) do
    "#{field}=#{operator}.#{value}"
  end

  def valid_operator?(operator) do
    Enum.member?(@valid_operators, operator)
  end
end
