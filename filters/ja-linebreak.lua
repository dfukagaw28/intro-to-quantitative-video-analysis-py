-- 日本語の文の途中や文と文の間にある改行を、空白として出力しないようにする。
-- これにより、原稿を「1文1行」で書いても、表示に余計な空白が入らない。
-- 改行の前後どちらかが全角文字（かな・漢字・全角記号）の場合だけ取り除く。

local function is_wide(cp)
  return cp ~= nil and (
    (cp >= 0x3000 and cp <= 0x30FF) or  -- 句読点、ひらがな、カタカナ
    (cp >= 0x3400 and cp <= 0x9FFF) or  -- 漢字
    (cp >= 0xFF00 and cp <= 0xFFEF))    -- 全角英数・記号
end

local function last_cp(el)
  if el and el.t == "Str" and #el.text > 0 then
    local pos = utf8.offset(el.text, -1)
    return utf8.codepoint(el.text, pos)
  end
end

local function first_cp(el)
  if el and el.t == "Str" and #el.text > 0 then
    return utf8.codepoint(el.text, 1)
  end
end

function Inlines(inlines)
  local out = pandoc.Inlines({})
  for i, el in ipairs(inlines) do
    local drop = el.t == "SoftBreak"
      and (is_wide(last_cp(inlines[i - 1])) or is_wide(first_cp(inlines[i + 1])))
    if not drop then
      out:insert(el)
    end
  end
  return out
end
