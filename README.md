# gropen

`gropen` is a simple command line application that helps you showing code in remote repositories.

> Although this version in Elixir was made for study purposes, it's totally ready to use.
  Someday I might come back with a more portable version written in either Crystal, Go or shell script.

## Installation

### Usual

1\. Erlang is required:

```
$ brew install erlang
```

2\. Run the installation script:

```
curl -sL https://raw.githubusercontent.com/tiagopog/gropen/master/install | sh
```

That's it!

### Docker


1\. Pull the image:

```
$ docker pull tiagopog/gropen
```

2\. Now it's all about to run the container:

```
$ docker run gropen my_awesome_module.exs:2 --link
```

3\. You can also alias the `docker run` in order to easily run the `gropen` executable:

```
$ echo 'alias gropen="docker run gropen"' >> ~/.zshrc
$ source ~/.zshrc
```

## Usage

### On terminal

```
$ gropen mix.exs:2
```

It will then open the following URL on your browser:

`https://github.com/tiagopog/gropen/blob/master/mix.exs#L2`


**Options:**

- *(--branch|-b) branch_name*:
  - Use another branch rather than the current one;
  - e.g. `gropen mix.ex:10 -b feature/awesome-branch`
- *(--link|-l)*:
  - Skip opening the URL on the browser;
  - e.g. `gropen mix.ex:10 -l`

### On iex

Add `gropen` to your `mix.exs` dependencies:

```elixir
def deps do
  [{:gropen, "~> 0.1.1"}]
end
```

And then call:

```elixir
Gropen.process({"mix.exs:2", [branch: "foobar", link: true]})
```

or

```elixir
Gropen.CLI.main(["mix.exs:2", "--branch", "foobar", "--link"])
```

## TODO

- [ ] Add support to other remote source repos: Gitlab, Bitbucket;
- [x] Add "--link" option to skip openning URLs on the browser;
- [ ] Copy the resulting URL to the clipboard;
- [ ] Generate URLs for commit hash;
- [x] Add support to relative paths;
- [ ] Create plugins for Vim, Sublime Text and Atom.
