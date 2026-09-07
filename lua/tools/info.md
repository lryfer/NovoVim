This folder automatically includes all the script that you feed into the directory
feel free to create scripts, if you fear that script might change in the future just 
launch an .sh file as a workaround in the script
```lua
    local Script_module = {}
    ---...
    --- script
    ---...
    vim.api.nvim_create_user_command("Script_name", function()
        Script_module.run()
    end, { desc = "Script desctription" })

    return Script_module
```
