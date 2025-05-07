return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load({include = { "html" }})
          local ls = require("luasnip")
          local fmt = require("luasnip.extras.fmt").fmt
          local rep = require("luasnip.extras").rep
          local s = ls.snippet
          local i = ls.insert_node
          ls.add_snippets(nil, {
          all = {
            s({
              trig = "element",
              name = "HtmlElement",
              dscr = "Quick snippet to create a full HTML element",
            }, fmt("<{}>{}</{}>", {
              i(1, "tag"), i(2), rep(1),
            })),
          },
        })
        ls.add_snippets(nil, {
        all = {
          s({
            trig = "html5",
            name = "HTML5 Boilerplate",
            dscr = "Quick HTML5 structure",
          }, fmt([[
            <!DOCTYPE html>
            <html lang="en">
            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>{}</title>
            </head>
            <body>
              {}
            </body>
            </html>
          ]], {
            i(1, "Document Title"), i(2),
          })),
        },
      })
      end;
}
