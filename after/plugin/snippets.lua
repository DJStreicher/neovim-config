local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("php", {
    s("foreach", {
        t("foreach ($"), i(1, "array"), t(" as $"), i(2, "value"), t(") :"),
        t({"", "    # code"}),  -- 4 spaces added here
        t({"", "endforeach;"})
    }),
    s("if", {
        t("if ("), i(1, "condition"), t(") :"),
        t({"", "    # code"}),  -- 4 spaces added here
        t({"", "endif;"})
    }),
    s("elseif", {
        t("elseif ("), i(1, "condition"), t(") :"),
        t({"", "    # code"}),  -- 4 spaces added here
    }),
    s("switch", {
        t("switch ($"), i(1, "variable"), t(") :"),
        t({"","    case 'value':"}),
        t({"", "        # code"}),  -- 4 spaces added here
        t({"", "        break;"}),
        t(""),
        t({"","    default:"}),
        t({"", "        # code"}),  -- 4 spaces added here
        t({"", "        break;"}),
        t({"", "endswitch;"}),
    })
})

