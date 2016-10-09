# gropen

`gropen` is a simple command line application that helps you showing code in remote repositories.

> Although this version in Elixir was made for study purposes, it's totally ready to use.
  Someday I might come back with a more portable version written in either Go or shell script.

## Installation

1\. Elixir is [required](http://elixir-lang.org/install.html#distributions).

2\. Run the installation script:

```
curl -sL https://raw.githubusercontent.com/tiagopog/gropen/master/install | sh
```

That's it!

## Usage

**On terminal:**

```
$ gropen mix.exs:2
```

It will then open the following URL on your browser:

`https://github.com/tiagopog/gropen/blob/master/mix.exs#L2`

**On iex:**

Add gropen to your `mix.exs` dependencies:

```elixir
def deps do
  [{:gropen, "~> 0.1.0"}]
end
```

And then call `Gropen.main/1`

```elixir
Gropen.main(["mix.exs:2", "--branch", "bar"])
```

## TODO

- [ ] Support more git-based source repos: Gitlab, Bitbucket;
- [ ] Add "--link" flag to build the URL and skip open it on a web browser;
- [ ] Copy the resulting URL to the clipboard;
- [ ] Generate URLs based on commits;
- [ ] Understand relative paths.
