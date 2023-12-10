function python3_package_setup {
    export _PYTHON_PROJECT_BASE=${BUILD_DIR}/python3${INSTALL_PREFIX}
    export PYTHONHOME=${BUILD_DIR}/python3${INSTALL_PREFIX}
    export PYTHONPATH=${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages:${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/python3.8:${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/python3.8/site-packages

    if [ ${ARCH_BASE} == 'linux' ]; then
        cp /usr/lib/python3.8/lib-dynload/* ${PYTHONHOME}/lib/python3.8/lib-dynload/.
        cp -r /usr/lib/python3/dist-packages/cairo ${PYTHONHOME}/lib/python3.8/lib-dynload/.
    elif [ ${ARCH_BASE} == 'darwin' ]; then
        cp /usr/lib/python3.8/lib-dynload/* ${PYTHONHOME}/lib/python3.8/lib-dynload/.
        cp -r /usr/lib/python3/dist-packages/cairo ${PYTHONHOME}/lib/python3.8/lib-dynload/.
    elif [ ${ARCH} == 'windows-x64' ]; then
        export DLLWRAP=x86_64-w64-mingw32-dllwrap 
        export HOME=/tmp
        cp /usr/lib64/python3.8/lib-dynload/* ${PYTHONHOME}/lib/python3.8/lib-dynload/.
        #cp -r /usr/lib64/python3.8/site-packages/cairo ${PYTHONHOME}/lib/python3.8/lib-dynload/.
        cp -r ${BUILD_DIR}/python3${INSTALL_PREFIX}/lib ${BUILD_DIR}/python3${INSTALL_PREFIX}/lib64
    fi

    if [ ${ARCH} == 'linux-arm' ]; then
        sed -i 's,/yosyshq/,'${PYTHONHOME}/',g' ${PYTHONHOME}/lib/python3.8/_sysconfigdata__linux_arm-linux-gnueabihf.py
    elif [ ${ARCH} == 'linux-arm64' ]; then
        sed -i 's,/yosyshq/,'${PYTHONHOME}/',g' ${PYTHONHOME}/lib/python3.8/_sysconfigdata__linux_aarch64-linux-gnu.py
    elif [ ${ARCH} == 'linux-riscv64' ]; then
        sed -i 's,/yosyshq/,'${PYTHONHOME}/',g' ${PYTHONHOME}/lib/python3.8/_sysconfigdata__linux_riscv64-linux-gnu.py
    elif [ ${ARCH} == 'linux-x64' ]; then
        sed -i 's,/yosyshq/,'${PYTHONHOME}/',g' ${PYTHONHOME}/lib/python3.8/_sysconfigdata__linux_x86_64-linux-gnu.py
    elif [ ${ARCH} == 'windows-x64' ]; then
        sed -i 's,/yosyshq/,'${PYTHONHOME}/',g' ${PYTHONHOME}/lib/python3.8/_sysconfigdata__win_.py
    elif [ ${ARCH} == 'darwin-x64' ]; then
        sed -i 's,/yosyshq/,'${PYTHONHOME}/',g' ${PYTHONHOME}/lib/python3.8/_sysconfigdata__darwin_darwin.py
    elif [ ${ARCH} == 'darwin-arm64' ]; then
        sed -i 's,/yosyshq/,'${PYTHONHOME}/',g' ${PYTHONHOME}/lib/python3.8/_sysconfigdata__darwin_darwin.py
    fi
}

function python3_package_install {
    install_cmd="setup.py install --prefix=${OUTPUT_DIR}${INSTALL_PREFIX} $1"
    if [ ${ARCH} == 'linux-arm' ]; then
        _PYTHON_HOST_PLATFORM=linux-arm  _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_arm-linux-gnueabihf python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-arm64' ]; then
        _PYTHON_HOST_PLATFORM=linux-aarch64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_aarch64-linux-gnu python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-riscv64' ]; then
        _PYTHON_HOST_PLATFORM=linux-riscv64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_riscv64-linux-gnu python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-x64' ]; then
        ${PYTHONHOME}/py3bin/python3 ${install_cmd}
    elif [ ${ARCH} == 'windows-x64' ]; then
        _PYTHON_HOST_PLATFORM=mingw-x64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__win_ python3.8 ${install_cmd}
    elif [ ${ARCH} == 'darwin-x64' ]; then        
        _PYTHON_HOST_PLATFORM=darwin-x64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__darwin_darwin python3.8 ${install_cmd}
    elif [ ${ARCH} == 'darwin-arm64' ]; then        
        _PYTHON_HOST_PLATFORM=darwin-aarch64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__darwin_darwin python3.8 ${install_cmd}
    fi
}

function python3_package_install_numpy {
    install_cmd="-m pip install --target ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages --no-cache-dir --disable-pip-version-check . $1"
    if [ ${ARCH} == 'linux-arm' ]; then
        _PYTHON_HOST_PLATFORM=linux-arm  _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_arm-linux-gnueabihf python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-arm64' ]; then
        _PYTHON_HOST_PLATFORM=linux-aarch64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_aarch64-linux-gnu python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-riscv64' ]; then
        _PYTHON_HOST_PLATFORM=linux-riscv64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_riscv64-linux-gnu python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-x64' ]; then
        ${PYTHONHOME}/py3bin/python3 ${install_cmd}
    elif [ ${ARCH} == 'windows-x64' ]; then
        _PYTHON_HOST_PLATFORM=mingw-x64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__win_ python3.8 setup.py build --cpu-dispatch="max -avx512f -avx512cd -avx512_knl -avx512_knm -avx512_skx -avx512_clx -avx512_cnl -avx512_icl" install --prefix=${OUTPUT_DIR}${INSTALL_PREFIX} $1
    elif [ ${ARCH} == 'darwin-x64' ]; then        
        _PYTHON_HOST_PLATFORM=darwin-x64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__darwin_darwin python3.8 ${install_cmd}
    elif [ ${ARCH} == 'darwin-arm64' ]; then        
        _PYTHON_HOST_PLATFORM=darwin-aarch64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__darwin_darwin python3.8 ${install_cmd}
    fi
}
function python3_package_develop {
    install_cmd="setup.py develop --prefix=${OUTPUT_DIR}${INSTALL_PREFIX} $1"
    if [ ${ARCH} == 'linux-arm' ]; then
        _PYTHON_HOST_PLATFORM=linux-arm  _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_arm-linux-gnueabihf python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-arm64' ]; then
        _PYTHON_HOST_PLATFORM=linux-aarch64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_aarch64-linux-gnu python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-riscv64' ]; then
        _PYTHON_HOST_PLATFORM=linux-riscv64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_riscv64-linux-gnu python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-x64' ]; then
        ${PYTHONHOME}/py3bin/python3 ${install_cmd}
    elif [ ${ARCH} == 'windows-x64' ]; then
        _PYTHON_HOST_PLATFORM=mingw-x64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__win_ python3.8 ${install_cmd}
    elif [ ${ARCH} == 'darwin-x64' ]; then
        _PYTHON_HOST_PLATFORM=darwin-x64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__darwin_darwin python3.8 ${install_cmd}
    elif [ ${ARCH} == 'darwin-arm64' ]; then
        _PYTHON_HOST_PLATFORM=darwin-aarch64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__darwin_darwin python3.8 ${install_cmd}
    fi
}

function python3_package_pip_install {
    install_cmd="-m pip install --target ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages --no-cache-dir --disable-pip-version-check $1"
    if [ ${ARCH} == 'linux-arm' ]; then
        _PYTHON_HOST_PLATFORM=linux-arm  _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_arm-linux-gnueabihf python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-arm64' ]; then
        _PYTHON_HOST_PLATFORM=linux-aarch64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_aarch64-linux-gnu python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-riscv64' ]; then
        _PYTHON_HOST_PLATFORM=linux-riscv64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_riscv64-linux-gnu python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-x64' ]; then
        ${PYTHONHOME}/py3bin/python3 ${install_cmd}
    elif [ ${ARCH} == 'windows-x64' ]; then
        _PYTHON_HOST_PLATFORM=mingw-x64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__win_ python3.8 ${install_cmd}
    elif [ ${ARCH} == 'darwin-x64' ]; then
        _PYTHON_HOST_PLATFORM=darwin-x64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__darwin_darwin python3.8 ${install_cmd}
    elif [ ${ARCH} == 'darwin-arm64' ]; then
        _PYTHON_HOST_PLATFORM=darwin-aarch64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__darwin_darwin python3.8 ${install_cmd}
    fi
}

function python3_package_pth {
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/easy_install*
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages/setuptools.pth 
    # rename easy-install.pth to prevent conflict with multiple files with same name
    mv ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages/easy-install.pth ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages/$1.pth
}
