set OPENSSL_DIR=%LIBRARY_PREFIX%

rem Upstream .cargo/config.toml sets +crt-static for *-pc-windows-msvc
rem (static CRT). Conda C deps and cc-rs objects are built against the
rem dynamic UCRT (/MD, or -fms-runtime-lib=dll with clang), so mixing them
rem leaves unresolved __imp_* symbols (e.g. __imp_clock from zstd-sys).
rem RUSTFLAGS takes precedence over target.<triple>.rustflags in the cargo
rem config, so this forces the dynamic CRT. The conda env provides the runtime.
set "RUSTFLAGS=%RUSTFLAGS% -Ctarget-feature=-crt-static"

rem Prevent memory exhaustion in CI
set CARGO_PROFILE_RELEASE_LTO=false

cd python

cargo-bundle-licenses ^
    --format yaml ^
    --output %SRC_DIR%\THIRDPARTY.yml ^
    || exit 1
   
%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
