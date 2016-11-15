defmodule GropenTest do
  use ExUnit.Case, async: true
  doctest Gropen

  test "generate URL without options (binary)" do
    {:ok, url, _} = Gropen.process("mix.exs")
    assert url ==  "https://github.com/tiagopog/gropen/blob/master/mix.exs"
  end

  test "generate URL with the code line" do
    {:ok, url, _} = Gropen.process("mix.exs:2")
    assert url ==  "https://github.com/tiagopog/gropen/blob/master/mix.exs#L2"
  end

  test "generate URL without options (tuple)" do
    {:ok, url, _} = Gropen.process({"mix.exs", []})
    assert url ==  "https://github.com/tiagopog/gropen/blob/master/mix.exs"
  end

  test "generate URL for a specific branch" do
    {:ok, url, options} = Gropen.process({"mix.exs", [branch: "foobar"]})
    assert url ==  "https://github.com/tiagopog/gropen/blob/foobar/mix.exs"
    assert options[:branch] == "foobar"
  end

  test "skip openning the URL on the browser" do
    # TODO: try testing this case with Hound or something
    {:ok, url, options} = Gropen.process({"mix.exs", [link: true]})
    assert url ==  "https://github.com/tiagopog/gropen/blob/master/mix.exs"
    assert options[:link] == true
  end
end
