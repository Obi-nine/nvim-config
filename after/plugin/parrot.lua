require("parrot").setup {
    providers = {
        anthropic = {
            name = "anthropic",
            endpoint = "https://api.anthropic.com/v1/messages",
            model_endpoint = "https://api.anthropic.com/v1/models",
            api_key = os.getenv('ANTHROPIC_API_KEY'),
            params = {
                chat = {
                    max_tokens = 8192,
                    model = "claude-sonnet-4-5-20250929"
                },
                command = {
                    max_tokens = 8192,
                    model = "claude-sonnet-4-5-20250929"
                },
            },
            topic = {
                model = "claude-3-5-haiku-20241022",
                params = { max_tokens = 32 },
            },
            headers = function(self)
                return {
                    ["Content-Type"] = "application/json",
                    ["x-api-key"] = self.api_key,
                    ["anthropic-version"] = "2023-06-01",
                }
            end,
            models = {
                "claude-sonnet-4-5-20250929",
                "claude-opus-4-5-20251101",
                "claude-haiku-4-5-20251001",
                "claude-sonnet-4-20250514",
                "claude-3-7-sonnet-20250219",
                "claude-3-5-sonnet-20241022",
                "claude-3-5-haiku-20241022",
            },
            preprocess_payload = function(payload)
                for _, message in ipairs(payload.messages) do
                    message.content = message.content:gsub("^%s*(.-)%s*$", "%1")
                end
                if payload.messages[1] and payload.messages[1].role == "system" then
                    payload.system = payload.messages[1].content
                    table.remove(payload.messages, 1)
                end
                return payload
            end,
        },
    },
   hooks = {
        ErrorCheck = function(prt, params)
            local bufnr = vim.api.nvim_get_current_buf()
            local filetype = vim.bo[bufnr].filetype

            local start_line = vim.fn.line("'<") - 1
            local end_line = vim.fn.line("'>") - 1

            -- Get selected text
            local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line + 1, false)
            local selection = table.concat(lines, "\n")

            -- Optional: Get surrounding context (10 lines before/after)
            local context_before = vim.api.nvim_buf_get_lines(
                bufnr, 
                math.max(0, start_line - 10), 
                start_line, 
                false
            )
            local context_after = vim.api.nvim_buf_get_lines(
                bufnr, 
                end_line + 1, 
                end_line + 11, 
                false
            )

            local diagnostics = vim.diagnostic.get(bufnr)
            local relevant_diagnostics = {}

            for _, diag in ipairs(diagnostics) do
                if diag.lnum >= start_line and diag.lnum <= end_line then
                    table.insert(relevant_diagnostics, {
                        line = diag.lnum + 1,
                        severity = vim.diagnostic.severity[diag.severity],
                        message = diag.message,
                    })
                end
            end

            local diagnostics_text = ""
            if #relevant_diagnostics > 0 then
                diagnostics_text = "\n\nDiagnostics:\n"
                for i, diag in ipairs(relevant_diagnostics) do
                    diagnostics_text = diagnostics_text .. 
                    string.format("%d. [%s] %s\n", i, diag.severity, diag.message)
                end
            end

            -- Build prompt with optional context
            local chat_prompt = string.format([[
                Fix this %s code with LSP diagnostics:

                Selected code:
                ```%s
                %s
                ```
                %s
                ]], filetype, filetype, selection, diagnostics_text
            )
            prt.ChatNew(params, chat_prompt)
        end
    },
}
