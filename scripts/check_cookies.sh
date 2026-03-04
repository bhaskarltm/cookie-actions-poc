#!/usr/bin/env bash
set -euo pipefail

echo "== Cookie policy check =="

# Look for cookie setting usage in your project folder
MATCHES=$(grep -R --line-number "Cookies.Append(" CookiePoC 2>/dev/null || true)

if [ -z "${MATCHES}" ]; then
  echo "No Cookies.Append(...) found. OK."
  exit 0
fi

echo "${MATCHES}"
echo ""

FAIL=0

# For PoC: if cookies are appended, require HttpOnly=true, Secure=true, SameSite=SameSiteMode.<...>
# This is a simple guardrail gate for demo purposes.
if ! grep -R "HttpOnly *= *true" CookiePoC >/dev/null 2>&1; then
  echo "❌ Missing HttpOnly=true in cookie options"
  FAIL=1
fi

if ! grep -R "Secure *= *true" CookiePoC >/dev/null 2>&1; then
  echo "❌ Missing Secure=true in cookie options"
  FAIL=1
fi

if ! grep -R "SameSite *= *SameSiteMode\." CookiePoC >/dev/null 2>&1; then
  echo "❌ Missing SameSite=SameSiteMode.<...> in cookie options"
  FAIL=1
fi

if [ "$FAIL" -eq 1 ]; then
  echo ""
  echo "Cookie policy check FAILED."
  echo "Fix guidance: set HttpOnly=true, Secure=true, SameSite=SameSiteMode.Strict/Lax/None"
  exit 2
fi

echo "Cookie policy check PASSED."
