# Guidelines for contributing

First of all, thank you for considering contributing! Below are guidelines for helping you contribute to this repository. 

## Raising an issue

### Bugs

Provide context to the bug and list any explorations you made. Reproducible examples are highly encouraged and may be asked for if not initially included.

### Features

Have an idea, big or small, for the package? Let the team know! Feature suggestions encourage development, give the team an idea how you and others use the package, and let you help shape the creative direction of the package.  

## Submitting a pull request

## Commit messages

*This is adapted from the Angular team's commit guidelines*

### Format of the commit message

A commit message consists of a header, a body, and a possible footer, separated by a blank line.

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

#### `<type>`

| value  | description |
| :----- | :----------- |
| feat  | feature |
| fix   | bug fix |
| docs  | documentation |
| style | formatting, missing semi colons, … |
| test  | adding missing tests |
| chore | maintenance |

#### `<scope>`

Scope can be anything specifying what the commit affects. For example renderBadge, tableInput, background, css, ...

Use * if there isn't a more fitting scope.

#### `<subject>`

This is a very short description of the change. 

* use imperative, present tense: “change” not “changed” nor “changes” 
* don't capitalize first letter
* no dot (.) at the end

#### `<body>`

As in `<subject>` use imperative, present tense: “change” not “changed” nor “changes”. Include the motivation for the change and contrasts with previous behavior.

#### `<footer>`

Optional, included in the following cases, 

##### Breaking changes

All breaking changes have to be mentioned as a breaking change block in the footer, which should start with the word BREAKING CHANGE:, subsequent lines should be intended four spaces. The rest of the commit message is then the description of the change, justification and migration notes. 

e.g.
```
BREAKING CHANGE: removed arugment from tableInput,
    this argrument was remove because ...
```

##### Referencing issues

Closed bugs should be listed on a separate line in the footer prefixed with "Closes" keyword like this:

Closes #234

or in case of multiple issues:

Closes #123, #245, #992
