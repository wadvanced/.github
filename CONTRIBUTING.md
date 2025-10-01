# Contributing to Dev Toolkit

First off, thank you for considering contributing to Dev Toolkit! It's people like you that make the open-source community such a great place.

## How Can I Contribute?

### Reporting Bugs

- **Ensure the bug was not already reported** by searching on GitHub under [Issues](https://github.com/wadvanced/dev-toolkit/issues).
- If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/wadvanced/dev-toolkit/issues/new). Be sure to include a **title and clear description**, as much relevant information as possible, and a **code sample** or an **executable test case** demonstrating the expected behavior that is not occurring.

### Suggesting Enhancements

- Open a new issue to discuss your enhancement. Please provide a clear description of the enhancement and its potential benefits.

### Pull Requests

1.  **Fork the repository** and create your branch from `main`.
2.  **Make your changes**.
3.  **Update the documentation** if you've changed anything.
4.  **Issue that pull request!**

## Style Guides

### Git Commit Messages

We adhere to the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification. This leads to a more readable commit history and allows for automated changelog generation.

The commit message should be structured as follows:

```
type(scope): subject

body

footer
```

**Types**

The `type` must be one of the following:

- `feat`: A new feature for the user.
- `fix`: A bug fix for the user.
- `docs`: Changes to documentation only.
- `style`: Code style changes (e.g., formatting, white-space).
- `refactor`: A code change that neither fixes a bug nor adds a feature.
- `test`: Adding missing tests or correcting existing tests.
- `chore`: Routine tasks, maintenance, or changes to the build process.
- `build`: Changes that affect the build system or external dependencies.
- `ci`: Changes to our CI configuration files and scripts.

**Scope**

The `scope` provides context for the commit. It's an optional part of the message that can be used to specify the area of the codebase affected by the change (e.g., `ai`, `coding/elixir`, `docs_templates`).

**Subject**

The subject contains a succinct description of the change:

- Use the imperative, present tense: "add" not "added" nor "adds".
- Don't capitalize the first letter.
- No dot (.) at the end.
