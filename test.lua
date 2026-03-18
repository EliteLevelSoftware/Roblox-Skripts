-- ═══════════════════════════════════════════════
-- ELS — Xeno Nested Loadstring Test
-- Paste the ONE-LINER below into Xeno to test:
--
-- loadstring(game:HttpGet("YOUR_RAW_URL"))()
--
-- This script tests whether Xeno allows nested
-- loadstrings when launched from a loader.
-- ═══════════════════════════════════════════════

print("[ELS Test] Script executing...")

-- Test 1: Basic execution reached
print("[ELS Test] ✓ Top-level execution OK")

-- Test 2: Can we call loadstring at this level?
local testFn, testErr = loadstring("return 1 + 1")
if testFn then
    local ok, result = pcall(testFn)
    if ok and result == 2 then
        print("[ELS Test] ✓ loadstring() works at this level")
    else
        print("[ELS Test] ✗ loadstring() ran but returned wrong result: " .. tostring(result))
    end
else
    print("[ELS Test] ✗ loadstring() blocked at this level: " .. tostring(testErr))
end

-- Test 3: Can we call game:HttpGet + loadstring (simulated — no actual fetch)?
local httpOk = pcall(function()
    local src = game:HttpGet("https://raw.githubusercontent.com/EliteLevelSoftware/EliteLevelUI-Library/refs/heads/main/EliteUI", true)
    if not src or #src < 100 then
        print("[ELS Test] ✗ HttpGet returned empty/short result: " .. tostring(src and #src or "nil"))
        return
    end
    print("[ELS Test] ✓ HttpGet succeeded, got " .. #src .. " bytes")

    local fn, err = loadstring(src)
    if fn then
        print("[ELS Test] ✓ loadstring(HttpGet()) compiled OK")
    else
        print("[ELS Test] ✗ loadstring(HttpGet()) failed to compile: " .. tostring(err))
    end
end)

if not httpOk then
    print("[ELS Test] ✗ HttpGet+loadstring test threw an error")
end

-- Test 4: HttpGet with true flag (Xeno bypass attempt)
local httpOk2 = pcall(function()
    local src2 = game:HttpGet("https://sirius.menu/rayfield", true)
    if not src2 or #src2 < 100 then
        print("[ELS Test] ✗ HttpGet(url, true) returned empty")
        return
    end
    print("[ELS Test] ✓ HttpGet(url, true) succeeded, got " .. #src2 .. " bytes")

    local fn2, err2 = loadstring(src2)
    if fn2 then
        print("[ELS Test] ✓ loadstring(HttpGet(url, true)) compiled OK — Xeno allows this!")
    else
        print("[ELS Test] ✗ loadstring(HttpGet(url, true)) blocked: " .. tostring(err2))
    end
end)

if not httpOk2 then
    print("[ELS Test] ✗ HttpGet(url, true) test threw an error")
end

print("[ELS Test] Done. Check output above.")
print("[ELS Test] If tests 3 or 4 show ✗ blocked, Xeno is blocking nested loadstrings.")
print("[ELS Test] If test 4 shows ✓, use game:HttpGet(url, true) in the script.")
