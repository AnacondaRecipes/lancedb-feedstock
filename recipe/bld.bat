set OPENSSL_DIR=%LIBRARY_PREFIX%

rem Upstream pins +crt-static in .cargo/config.toml for windows-msvc targets,
rem but conda-forge compiles C code against the dynamic CRT
rem (-fms-runtime-lib=dll), so the mixed-CRT link fails with unresolved
rem __imp_* symbols (e.g. __imp_clock from zstd-sys). RUSTFLAGS overrides the
rem workspace config and aligns the Rust link on the dynamic CRT.
set "RUSTFLAGS=-Ctarget-feature=-crt-static"

cd python

cargo-bundle-licenses ^
    --format yaml ^
    --output %SRC_DIR%\THIRDPARTY.yml ^
    || exit 1
   
%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
