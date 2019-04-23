defmodule QueryTest do
  alias PostgrestClient.Query
  alias PostgrestClient.Filter
  use ExUnit.Case

  test "query creation with FROM" do
    q = Query.from("test_table")

    assert %Query{from: "test_table"} = q
    assert "http://root/test_table" = q |> Query.to_string("root")
  end

  test "query chaining with FROM" do
    q =
      Query.from("test_table")
      |> Query.from("overwrite_table")

    assert %Query{from: "overwrite_table"} = q
    assert "http://root/overwrite_table" = q |> Query.to_string("root")
  end

  test "query with single SELECT parameter" do
    q =
      Query.from("test_table")
      |> Query.select(["field1"])

    assert %Query{from: "test_table", select: ["field1"]} = q
    assert "http://root/test_table?select=field1" = q |> Query.to_string("root")
  end

  test "query with multiple SELECT parameter" do
    q =
      Query.from("test_table")
      |> Query.select(["field1", "field2"])

    assert %Query{from: "test_table", select: ["field1", "field2"]} = q
    assert "http://root/test_table?select=field1,field2" = q |> Query.to_string("root")
  end

  test "query with single WHERE clause" do
    q =
      Query.from("test_table")
      |> Query.where("name", :is, "jon")

    assert %Query{
             from: "test_table",
             filters: [%Filter{field: "name", operator: :is, value: "jon"}]
           } = q

    assert "http://root/test_table?name=is.jon" = q |> Query.to_string("root")
  end

  test "query with multiple WHERE clauses" do
    q =
      Query.from("test_table")
      |> Query.where("name", :is, "jon")
      |> Query.where("age", :lte, 37)

    assert %Query{
             from: "test_table",
             filters: [
               %Filter{field: "name", operator: :is, value: "jon"},
               %Filter{field: "age", operator: :lte, value: 37}
             ]
           } = q

    assert "http://root/test_table?name=is.jon&age=lte.37" = q |> Query.to_string("root")
  end

  test "query with multiple WHERE clauses and SELECT parameter at the end" do
    q =
      Query.from("test_table")
      |> Query.where("name", :is, "jon")
      |> Query.where("age", :lte, 37)
      |> Query.select(["field1", "field2"])

    assert %Query{
             from: "test_table",
             select: ["field1", "field2"],
             filters: [
               %Filter{field: "name", operator: :is, value: "jon"},
               %Filter{field: "age", operator: :lte, value: 37}
             ]
           } = q

    assert "http://root/test_table?select=field1,field2&name=is.jon&age=lte.37" =
             q |> Query.to_string("root")
  end

  test "query with multiple WHERE clauses and SELECT parameter at the beginning" do
    q =
      Query.from("test_table")
      |> Query.select(["field1", "field2"])
      |> Query.where("name", :is, "jon")
      |> Query.where("age", :lte, 37)

    assert %Query{
             from: "test_table",
             select: ["field1", "field2"],
             filters: [
               %Filter{field: "name", operator: :is, value: "jon"},
               %Filter{field: "age", operator: :lte, value: 37}
             ]
           } = q

    assert "http://root/test_table?select=field1,field2&name=is.jon&age=lte.37" =
             q |> Query.to_string("root")
  end

  test "query with invalid filter operator" do
    q =
      Query.from("test_table")
      |> Query.where("name", :invalid, "jon")

    assert %Query{
             from: "test_table",
             error: "'invalid' is an invalid operator!"
           } = q
  end
end
