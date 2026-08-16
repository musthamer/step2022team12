# step2022team12 - Buecherwelt

Cleaned and modernized CGI project in folder `SWE`.

## What Is Included

- Public catalog with search/filter (works without login)
- Side panel for `Login` and `Registrierung`
- Admin flow for add/remove books after login
- Clean data files and deduplicated catalog

Main files:

- `SWE/index.html`
- `SWE/buecherwelt.sh` (stable ASCII catalog endpoint)
- `SWE/register.sh`
- `SWE/login.sh`
- `SWE/books.csv`
- `SWE/accounts.csv`

## Download Project

### Option 1: Git clone

```bash
git clone git@github.com:musthamer/step2022team12.git
cd step2022team12
```

### Option 2: GitHub ZIP

1. Open repository page on GitHub.
2. Click `Code`.
3. Click `Download ZIP`.
4. Extract archive and open folder `step2022team12`.

## Run Locally (Windows + WSL)

Requirements:

- Windows with WSL enabled
- Python 3 inside WSL

Start server:

```bash
cd /mnt/c/Users/<YOUR_USER>/path/to/step2022team12/SWE
python3 local_server.py
```

Open in browser:

- `http://localhost:18080/index.html`
- Catalog directly: `http://localhost:18080/buecherwelt.sh`

## How To Use

1. Open home page.
2. Search books directly from catalog (no login needed).
3. Optional: create account from `Registrierung` panel.
4. Optional: login for admin actions (add/remove books).

## Default Test Accounts

- `alex / 1234`
- `chris / 2022`

## Stop Server / Close Port

If running in terminal, press:

```text
Ctrl + C
```

If process is still running on port `18080`:

PowerShell:

```powershell
Get-NetTCPConnection -State Listen | Where-Object { $_.LocalPort -eq 18080 } |
ForEach-Object { Stop-Process -Id $_.OwningProcess -Force }
```

## Notes

- Use `buecherwelt.sh` endpoint for stable routing.
- Data is stored in plain CSV files in `SWE`.
