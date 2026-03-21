#!/usr/bin/env bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Source the function from symlink.sh
# Because we refactored symlink.sh to be sourceable, we can now source it directly
# without triggering the main logic.
if [ -f "./symlink.sh" ]; then
  source ./symlink.sh
else
  echo -e "${RED}ERROR${NC}: symlink.sh not found!"
  exit 1
fi

# Verify the function exists after sourcing
if ! declare -f containsElement > /dev/null; then
  echo -e "${RED}ERROR${NC}: containsElement function not found after sourcing symlink.sh"
  exit 1
fi

# Test suite
test_contains_element() {
  local total_tests=0
  local passed_tests=0

  assert_contains() {
    ((total_tests++))
    local match="$1"
    shift
    if containsElement "$match" "$@"; then
      echo -e "${GREEN}PASS${NC}: Found '$match' in ($*)"
      ((passed_tests++))
    else
      echo -e "${RED}FAIL${NC}: Could not find '$match' in ($*)"
      return 1
    fi
  }

  assert_not_contains() {
    ((total_tests++))
    local match="$1"
    shift
    if ! containsElement "$match" "$@"; then
      echo -e "${GREEN}PASS${NC}: Correctly did not find '$match' in ($*)"
      ((passed_tests++))
    else
      echo -e "${RED}FAIL${NC}: Unexpectedly found '$match' in ($*)"
      return 1
    fi
  }

  echo "Running containsElement tests..."

  # Happy path
  local arr=("apple" "banana" "cherry")
  assert_contains "apple" "${arr[@]}"
  assert_contains "banana" "${arr[@]}"
  assert_contains "cherry" "${arr[@]}"

  # Edge cases
  assert_not_contains "dragonfruit" "${arr[@]}"
  assert_not_contains "app" "${arr[@]}" # Partial match
  assert_not_contains "" "${arr[@]}" # Empty string match

  # Empty array
  local empty_arr=()
  assert_not_contains "anything" "${empty_arr[@]}"

  # Special characters
  local special_arr=("*" "?" "[" " ")
  assert_contains "*" "${special_arr[@]}"
  assert_contains "?" "${special_arr[@]}"
  assert_contains "[" "${special_arr[@]}"
  assert_contains " " "${special_arr[@]}"

  echo "---------------------------------------"
  echo "Tests completed: $passed_tests/$total_tests passed."

  if [ "$passed_tests" -eq "$total_tests" ]; then
    return 0
  else
    return 1
  fi
}

test_contains_element
exit $?
