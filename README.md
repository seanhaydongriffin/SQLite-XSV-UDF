# SQLite-XSV-UDF
An AutoIt UDF for CSV file manipulation using sqlite-xsv

## Amalgamating SQLite3 and sqlite-xsv into a single DLL

The following steps I followed to amalgamate SQLite + sqlite-xsv + auto-registered CSV module together into a Single DLL that could be used in AutoIt.

Goal: one DLL, e.g. sqlite3_xsv.dll, that:
- embeds SQLite
- embeds the xsv CSV virtual table
- auto‑registers the CSV module at startup
- is loaded by AutoIt via _SQLite_Startup() with no sqlite3_load_extension() calls.

### Step 1 - download the SQLite Amalgamation
https://sqlite.org/amalgamation.html
https://sqlite.org/download.html

### Step 2 - download the Github repo for sqlite-xsv
https://github.com/asg017/sqlite-xsv

### Step 3 - Install Rust (includes Cargo) - if you have not done previously
https://www.rust-lang.org/tools/install

### Step 4 - Install the MSVC Build Tools (C compiler + linker) - if you have not done previously
https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio

During installation, select:
- Desktop development with C++

### Step 5 - Install LLVM + Clang - if you have not done previously
Download LLVM (Clang) for Windows and run the installer

This installs:

```
C:\Program Files\LLVM\bin\clang.exe
C:\Program Files\LLVM\bin\libclang.dll
```

in the command prompt run:

`setx LIBCLANG_PATH "C:\Program Files\LLVM\bin"`

to tell bindgen where libclang is

### Step 5 - Build the xsv static library
In the command prompt:

Navigate to your sqlite‑xsv folder

Build release version:

`cargo build --release`

This produces:

```
target\release\sqlite_xsv.lib   (static)
```

### Step 6 - Create init_xsv.c
Put this in the SQLite Amalgamation folder

```
#include "sqlite3ext.h"
SQLITE_EXTENSION_INIT1

extern int sqlite3_xsv_init(sqlite3 *db, char **pzErrMsg, const sqlite3_api_routines *pApi);

/* Exported entry point for SQLite */
__declspec(dllexport)
int sqlite3_extension_init(sqlite3 *db, char **pzErrMsg, const sqlite3_api_routines *pApi)
{
    return sqlite3_xsv_init(db, pzErrMsg, pApi);
}
```

### Step 7 - Build the DLL using MSVC
Open a Developer Command Prompt for VS 2022.

Navigate (cd) into the SQLite Amalgamation folder.

Run this command (replacing the paths as required):

`cl /LD /Fe:sqlite3_xsv.dll /DSQLITE_ENABLE_VIRTUAL_TABLE /DSQLITE_ENABLE_COLUMN_METADATA /DSQLITE_API=__declspec(dllexport) sqlite3.c init_xsv.c sqlite-xsv-main\target\release\sqlite_xsv.lib ws2_32.lib ntdll.lib userenv.lib msvcrt.lib`

If everything is correct, MSVC will produce:

```
sqlite3_xsv.dll
sqlite3_xsv.lib
sqlite3_xsv.exp
```

### Step 8 — Test the DLL in AutoIt
