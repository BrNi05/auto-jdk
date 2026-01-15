# Auto JDK

Cross-platform scripts to download, install, and configure JDK 25.

## Supported platforms

- Linux
- macOS
- Windows

## What the scripts do

- Install JDK 25
- Configue JAVA_HOME
- Update PATH
- Handle some frequent errors

> [!IMPORTANT]
> Maven is intentionally **not** installed. Use the Maven Wrapper (`mvnw`) on a per-project basis.

## Prerequisites

### Linux

- `bash`
- `wget`
- `tar`
- `sudo` (and root privileges)

### macOS

- `Homebrew` installed
- `bash`

### Windows

- `PowerShell`
- Administrator privileges

## Usage

> [!WARNING]
> If you have previously installed JDK(s), be sure to first remove at least the `JAVA_HOME` assignments and related `PATH` overrides.

### Linux

``` bash
curl -fsSL https://raw.githubusercontent.com/BrNi05/auto-jdk/main/linux.sh | sudo bash
```

### macOS

``` bash
curl -fsSL https://raw.githubusercontent.com/BrNi05/auto-jdk/main/macos.sh | bash
```

### Windows

> [!IMPORTANT]
> Open PowerShell **as Administrator** before running this command.

``` bash
iwr -useb https://raw.githubusercontent.com/BrNi05/auto-jdk/main/windows.ps1 | iex
```

> [!TIP]
> This might take a few minutes to complete.

### After installation

- Restart the terminal or log out and back in
- Verify the install success: `java -version` or `javac -version`.

## Notes

- Existing `JAVA_HOME` and `PATH` entries may conflict - the scripts warn before proceeding. Manual steps may be required.

- Multiple JDKs installed in parallel are NOT recommended.

- Changes to environment variables require a new shell session to take effect.
