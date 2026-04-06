set OPENSSL_DIR=%LIBRARY_PREFIX%

cd python

cargo-bundle-licenses ^
    --format yaml ^
    --output %SRC_DIR%\THIRDPARTY.yml ^
    || exit 1
   
%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
