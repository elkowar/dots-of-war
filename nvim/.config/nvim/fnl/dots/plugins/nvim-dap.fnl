(module dots.plugins.nvim-dap
  {autoload {a aniseed.core
             utils dots.utils
             dap dap}})
              

(set dap.adapters.cpp
     {:type "executable"
      :attach {:pidProperty "pid" :pidSelect "ask"}
      :command "lldb-vscode"
      :env {:LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY "yes"}
      :name "lldb"})

;; TODO This does not really work,.. REEEEEEEEEEEEEEE
(set dap.adapters.rust
     {:type "executable"
      :attach {:pidProperty "pid" :pidSelect "ask"}
      :command "lldb-vscode"
      :env {:LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY "yes"}
      :name "lldb"
      :initCommands ["command script import \"/home/leon/.rustup/toolchains/nightly-2021-03-18-x86_64-unknown-linux-gnu/lib/rustlib/etc/lldb_lookup.py\""
                     "type summary add --no-value --python-function lldb_rust_formatters.print_val -x \".*\" --category Rust"
                     "type category enable Rust"]})

(set dap.adapters.node2
     {:type "executable"
      :command "node"
      :args ["/home/leon/tmp/vscode-node-debug2/out/src/nodeDebug.js"]})

(set dap.configurations.javascript 
   [{:name "javascript"
     :type "node2"
     :request "launch"
     :program "${workspaceFolder}/${file}"
     :cwd (vim.fn.getcwd)
     :sourceMaps true
     :protocol "inspector"
     :console "integratedTerminal"}])
