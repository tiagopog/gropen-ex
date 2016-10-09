# gropen

`gropen` is a simple command line application that helps you showing code in remote repositories.

| Although this version in Elixir was made for study purposes, it's totally ready to use.
| Someday I might come back with a more portable version written in either Go or shell script.

## Installation

Elixir/Erlang is [required](http://elixir-lang.org/install.html#distributions).

TODO

## Usage


On iex:

```elixir
Gropen.main(["mix.exs:2", "--branch", "bar"])
```

On terminal:

```shell
$ gropen mix.exs:2 --branch bar
```

TODO

## TODO

- [ ] Support more git-based source repos: Gitlab, Bitbucket;
- [ ] Add "--link" flag to build the URL and skip open it on a web browser;
- [ ] Generate URLs for commit revisions;
- [ ] Understand files at their relative paths;
- [ ] Write a Go version in order to make it more portable.
