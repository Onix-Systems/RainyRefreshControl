# Contributing - How we add to the product

## General

* Each message (issue, commit, pull request) starts with a verb
* Each message starts with an uppercase and doesn't end with a period
* Each message starts with a line that is less than 80 characters long

**Examples:**

* _Design login workflow_
* _Update to latest version of Play tools_
* _Improve display of CI failures_


## Issues

* Each issue represents a single problem
* Each issue has a milestone attached

## Milestones

* Each milestone needs to match one of the following patterns:
 * semantic version number (`1.0`, `1.0.5`)
 * semantic version number with a wildcard (`2.x`, `2.1.x`)
 * `undecided` - issues we want to keep, but aren't sure when we'll address
 * `invalid` - issues that were duplicate, invalid (or similar) go here to avoid upsetting milestone counts

# Versioning

## Commits

* Each commit represents a single change
* Each commit keeps the project fully functional
* Each commit message that closes an issue ends with `(close #XYZ)`

**Examples:**

* _Design login workflow (close #1)_
* _Fix typo in about dialog_
* _Document data model accessors (close #3, close #4)_

## Pull requests

* Each pull request represents a single problem
* Each pull request has a milestone attached
* Each pull request contains as few commits as needed
* Each pull request is rebased on latest `develop`
* Each pull request is free from fixup or revert commits

## Branches

* Use _true merge_ if it's desirable for the branch to remain visible in the long run
* Use _fast-forward merge_ for temporary branches

# Workflow

## Development

1. Create a feature branch `feature/xxx-yyy-zzz`
2. Make and commit changes
3. Create a pull request against `develop`
4. Go through code review
5. See your pull request merged

## Deployment

1. Branch out `release/X.Y.Z` from `develop`
2. Test the release
3. Merge the release branch to `master`
4. Tag the merge commit as `vX.Y.Z`
5. Delete the release branch
6. Deploy from `master` branch

# Code

## General

1. No magic numbers in storyboards. To have space between views - use layout margins. To get even more space - use embed views.
1. Extention vs subclassing. Avoid subclassing and use protocols instead. One can [google](https://www.google.com.ua/search?client=safari&rls=en&q=swift+protocol+vs+subclass&ie=UTF-8&oe=UTF-8&gfe_rd=cr&ei=SjkHWKOKD5Gr8wfRv6OoDQ) about it or check [this](http://mikebuss.com/2016/01/10/interfaces-vs-inheritance/) artcile or [this](http://krakendev.io/blog/subclassing-can-suck-and-heres-why) or even [this](https://www.natashatherobot.com/swift-2-0-protocol-oriented-mvvm/).
1. Use `NSLocalizedString` for all strings visible to user.
