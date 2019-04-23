defmodule PostgrestClient.Helpers do
  def blank?(string) do
    String.equivalent?(string, "")
  end

  def if_not_blank("", _template) do
    ""
  end

  def if_not_blank(string, template) do
    template.(string)
  end
end
