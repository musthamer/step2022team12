# step2022team12 - Buecherwelt (Clean Edition)

This repository now contains the cleaned and updated CGI-based `SWE` project only.

## Project Folder

- `SWE/`

## What's Updated

- Modernized frontend design (`index.html`, `impressum.html`, `style.css`)
- Fixed and hardened CGI scripts:
  - `Bücherwelt.sh` (catalog + search)
  - `login.sh` (credential check)
  - `bookform.sh` (admin actions)
  - `addbook.sh` (append book)
  - `removebook.sh` (remove selected entries)
- Removed hardcoded legacy paths (`/home/docker-marsell/...`) and switched to local project-relative files
- Added/standardized `SWE/accounts.csv` for login credentials

## Local Data Files

- `SWE/books.csv`
- `SWE/accounts.csv`

## Example Credentials

- `alex / 1234`
- `chris / 2022`

## Notes

- CGI scripts are designed for a server that executes `.sh` as CGI.
- Static pages and CGI output share the same visual style.
