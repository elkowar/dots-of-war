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
