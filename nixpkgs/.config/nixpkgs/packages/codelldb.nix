{ stdenv, symlinkJoin, makeWrapper, writeScriptBin, vscode-extensions }:
writeScriptBin "codelldb" ''
    ${vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/.codelldb-wrapped_ \
    --liblldb ${vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/lldb/lib/liblldb.so $@
    ''
#writeScriptBin "codelldb" ''
    #${vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/.codelldb-wrapped_ \
    #--liblldb ${vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/lldb/lib/liblldb.so $@
    #''
