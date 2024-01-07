local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet

ls.add_snippets( "tex", {
    s( { trig = ";em", name = "emph", dscr = "Emphasize text", 
        snippetType = "autosnippet" }, {
            t({"\\emph{"}), i(1, "text"),
            t({"}"}), i(0)
        }),
    s( { trig = ";bf", name = "textbf", dscr = "Bold face text",
        snippetType = "autosnippet" }, {
            t({"\\textbf{"}), i(1, "text"),
            t({"}"}), i(0)
        }),
    s( { trig = ";tt", name = "texttt", dscr = "Monospace text",
        snippetType = "autosnippet" }, {
            t({"\\texttt{"}), i(1, "text"),
            t({"}"}), i(0)
        }),
    s( { trig = ";sc", name = "textsc", dscr = "Small caps",
        snippetType = "autosnippet" }, {
            t({"\\textsc{"}), i(1, "text"),
            t({"}"}), i(0)
        }),
    s( { trig = ";ol", name = "enumerate", dscr = "Enumerate environment",
        snippetType = "autosnippet" }, {
            t({"\\begin{enumerate}", "    \\item "}), i(1, "item"),
            t({"", "\\end{enumerate}", ""}), i(0)
        }),
    s( { trig = ";ul", name = "itemize", dscr = "Itemize environment",
        snippetType = "autosnippet" }, {
            t({"\\begin{itemize}", "    \\item "}), i(1, "item"),
            t({"", "\\end{itemize}", ""}), i(0)
        }),
    s( { trig = ";li", name = "item", dscr = "List item",
        snippetType = "autosnippet" }, {
            t({"\\item "}), i(1, "item")
        }),
    s( { trig = ";chn", name = "chapter", dscr = "Chapter (numbered)",
        snippetType = "autosnippet" }, {
            t({"\\chapter{"}), i(1, "Chapter title"),
            t({"}"}), i(0)
        }),
    s( { trig = ";chu", name = "chapter*", dscr = "Chapter (unnumbered)",
        snippetType = "autosnippet" }, {
            t({"\\chapter*{"}), i(1, "Chapter title"),
            t({"}"}), i(0)
        }),
    s( { trig = ";secn", name = "section", dscr = "Section (numbered)",
        snippetType = "autosnippet" }, {
            t({"\\section{"}), i(1, "Section title"),
            t({"}"}), i(0)
        }),
    s( { trig = ";secu", name = "section*", dscr = "Section (unnumbered)",
        snippetType = "autosnippet" }, {
            t({"\\section*{"}), i(1, "Section title"),
            t({"}"}), i(0)
        }),
    s( { trig = ";ssecn", name = "subsection", dscr = "Subsection (numbered)",
        snippetType = "autosnippet" }, {
            t({"\\subsection{"}), i(1, "Subsection title"),
            t({"}"}), i(0)
        }),
    s( { trig = ";ssecu", name = "subsection*", dscr = "Subsection (unnumbered)",
        snippetType = "autosnippet" }, {
            t({"\\subsection*{"}), i(1, "Subsection title"),
            t({"}"}), i(0)
        }),
    s( { trig = ";sssecn", name = "subsubsection", dscr = "Subsubsection (numbered)",
        snippetType = "autosnippet" }, {
            t({"\\subsubsection{"}), i(1, "Subsubsection title"),
            t({"}"}), i(0)
        }),
    s( { trig = ";sssecu", name = "subsubsection*", dscr = "Subsubsection (unnumbered)",
        snippetType = "autosnippet" }, {
            t({"\\subsubsection*{"}), i(1, "Subsubsection title"),
            t({"}"}), i(0)
        }),
    s( { trig = ";para", name = "paragraph", dscr = "Paragraph",
        snippetType = "autosnippet" }, {
            t({"\\paragraph{"}), i(1, "Paragraph title"),
            t({"}"}), i(0)
        }),
    s( { trig = ";vv", name = "in vivo", dscr = "in vivo",
        snippetType = "autosnippet" }, {
            t({"\\emph{in vivo}"})
        }),
    s( { trig = ";vt", name = "in vitro", dscr = "in vitro",
        snippetType = "autosnippet" }, {
            t({"\\emph{in vitro}"})
        }),
    s( { trig = ";a", name = "link", dscr = "Hypertext link",
        snippetType = "autosnippet" }, {
            t({"\\href{"}), i(1, "link"),
            t({"}"}), i(0)
        }),
    s( { trig = ";cp", name = "clearpage", dscr = "clearpage",
        snippetType = "autosnippet" }, {
            t({"\\clearpage"})
        }),
}
)
ls.filetype_extend("plaintex", { "tex" })

ls.add_snippets( "markdown", {
    s( { trig = ";e", name = "emph", dscr = "Emphasize text", 
        snippetType = "autosnippet" }, {
            t({"*"}), i(1, "text"),
            t({"*"}), i(0)
        }),
    s( { trig = ";b", name = "bold", dscr = "Bold text", 
        snippetType = "autosnippet" }, {
            t({"**"}), i(1, "text"),
            t({"**"}), i(0)
        }),
    s( { trig = ";a", name = "link", dscr = "Hypertext link", 
        snippetType = "autosnippet" }, {
            t({"["}), i(1, "text"),
            t({"]("}), i(2, "link"),
            t({")"}), i(0)
        }),
    s( { trig = ";i", name = "image", dscr = "Image", 
        snippetType = "autosnippet" }, {
            t({"!["}), i(1, "caption"),
            t({"]("}), i(2, "path"),
            t({")"}), i(0)
        }),
    s( { trig = ";1", name = "#", dscr = "First level heading", 
        snippetType = "autosnippet" }, {
            t({"# "}), i(1, "Heading"),
            t({ "", "" }), i(0)
        }),
    s( { trig = ";2", name = "##", dscr = "Second level heading", 
        snippetType = "autosnippet" }, {
            t({"## "}), i(1, "Heading"),
            t({ "", "" }), i(0)
        }),
    s( { trig = ";3", name = "###", dscr = "Third level heading", 
        snippetType = "autosnippet" }, {
            t({"### "}), i(1, "Heading"),
            t({ "", "" }), i(0)
        }),
    s( { trig = ";4", name = "####", dscr = "Fourth level heading", 
        snippetType = "autosnippet" }, {
            t({"#### "}), i(1, "Heading"),
            t({ "", "" }), i(0)
        }),
    s( { trig = ";vv", name = "in vivo", dscr = "in vivo", 
        snippetType = "autosnippet" }, {
            t({"*in vivo*"})
        }),
    s( { trig = ";vt", name = "in vitro", dscr = "in vitro", 
        snippetType = "autosnippet" }, {
            t({"*in vitro*"})
        }),
    s( { trig = ";T", name = "title block", descr = "YAML title block",
        snippetType = "autosnippet" }, {
            t({"---", "title: \""}), i(1, "title"),
            t({"\"", "author: \""}), i(2, "author"),
            t({"\"", "date: "}), i(3, "date"),
            t({"---", "", ""}), i(0)
        })
})
ls.filetype_extend("rmarkdown", { "markdown" })
ls.filetype_extend("rmd", { "markdown" })
ls.filetype_extend("quarto", { "markdown" })
ls.filetype_extend("qmd", { "markdown" })
ls.filetype_extend("pandoc", { "markdown" })

ls.add_snippets( "go", {
    s( { trig = "ien", name = "if err != nil", dscr = "Basic error handling", 
        snippetType = "snippet" }, {
            t({"if err != nil {", ""}), 
            c(1, {
                t("    log.Fatal(err)"),
                i(nil, "    custom error handling")
            }),
            t({"", "}", ""}), i(0)
        }),
})
