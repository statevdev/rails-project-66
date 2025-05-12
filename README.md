[![Actions Status](https://github.com/statevdev/rails-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/statevdev/rails-project-66/actions)
[![CI Status](https://github.com/statevdev/rails-project-66/actions/workflows/main.yml/badge.svg)](https://github.com/statevdev/rails-project-66/actions)

# Github Code Quality Checker
This application it's a service for checking code in Github repositories.

It provides automatic selection of your repositories, including language selection and popular linter setting.

During the checkout, you will see where the error was found, the errors themselves, and a link to the corresponding commit. 

## Features:
- Github powered authorization and authentication
  - omniauth
- Parsing github repositories and setting webhooks on commit
  - octokit
- Pagination
  - kaminari
- Access control
  - pundit
- Internationalization (en; ru)
  - i18n
- Object containerization
  - dry-container
- Sending an error report to the mail
  - action-mailer & mailtrap

## Application link:
https://rails-project-66-l5zc.onrender.com/

## Installation
Requires Ruby=3.2.2

Execute this for setup:

```bash
make setup
```

## Usage

To start the local server on 3000 port, run:

```bash
make start
```