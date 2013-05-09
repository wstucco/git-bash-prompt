git-bash-prompt
===============

Git prompt for Bash shell

## Keep an eye on your code revision system ##

An higly configurable bashrc script to keep track of every change
in your repositories.
It shows the branch you are in and the status of the repository.

## What's included ##

Included in the package you'll find a skeleton for `.bash_profile`
that autoloads the scripts in your `~/.bashrc.d` folder and an autocomplete script for `git` commands.

## How it looks ##

I present you the **christmas tree configuration** in all its glory!
![christmas tree configuration](http://i.imgur.com/FVyP92k.png "X-mas tree bash prompt") 

All the colors, paths and prompt elements, are easily configurable.

## How it works ##

By default the prompt shows the following informations
+ your username
+ the hostname
+ the complete path you're currently in
+ git branch
+ one or more circles (●) each of them representing a warning (more on this later)
+ eventually a green check (✔), which means the repository is clean

The circles have the following meaning
+ green: there are untracked files
+ yellow: there are unstaged files
+ orange: there are uncommitted files
+ red: your repository is either ahead or behind the remote origin (you need to pull or push)

## TODO ##

- [x] alert when your repository is not synced with the remote origin
- [ ] create different prompts for users and root (root username and # are gonna be red, so you know you're running as root)
- [ ] different warnings for repositories that are ahead or behind the remote origin.Maybe an up arrow (↑) when commits are waiting to be pushed and a down one (↓) when you need to pull.


