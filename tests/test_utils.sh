#!/usr/bin/env bash

# Set up environment
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

# Test counter and failure flag
TEST_FAILURES=0

# Simple test runner functions
it() {
  printf "Testing %s... " "$1"
}

assert_success() {
  if "$@"; then
    printf "\033[1;32mPASSED\033[0m\n"
  else
    printf "\033[1;31mFAILED\033[0m\n"
    TEST_FAILURES=$((TEST_FAILURES + 1))
  fi
}

assert_failure() {
  if "$@"; then
    printf "\033[1;31mFAILED\033[0m\n"
    TEST_FAILURES=$((TEST_FAILURES + 1))
  else
    printf "\033[1;32mPASSED\033[0m\n"
  fi
}

# Run tests
echo "Running utils tests..."

# Test containsElement
it "containsElement finds element in array"
arr=("apple" "banana" "cherry")
assert_success containsElement "banana" "${arr[@]}"

it "containsElement does not find element not in array"
assert_failure containsElement "grape" "${arr[@]}"

it "containsElement handles empty array"
empty_arr=()
assert_failure containsElement "apple" "${empty_arr[@]}"

it "containsElement handles empty search string"
arr2=("apple" "" "cherry")
assert_success containsElement "" "${arr2[@]}"

# Test formatting functions
it "info formats output correctly"
output=$(info "Test Info" | cat -v)
expected="^[[1;34mTest Info^[[0m"
if [[ "$output" == "$expected" ]]; then
  printf "\033[1;32mPASSED\033[0m\n"
else
  printf "\033[1;31mFAILED\033[0m\n"
  echo "Expected: $expected"
  echo "Got:      $output"
  TEST_FAILURES=$((TEST_FAILURES + 1))
fi

it "success formats output correctly"
output=$(success "Test Success" | cat -v)
expected="^[[1;32mTest Success^[[0m"
if [[ "$output" == "$expected" ]]; then
  printf "\033[1;32mPASSED\033[0m\n"
else
  printf "\033[1;31mFAILED\033[0m\n"
  echo "Expected: $expected"
  echo "Got:      $output"
  TEST_FAILURES=$((TEST_FAILURES + 1))
fi

it "warning formats output correctly"
output=$(warning "Test Warning" | cat -v)
expected="^[[1;33mTest Warning^[[0m"
if [[ "$output" == "$expected" ]]; then
  printf "\033[1;32mPASSED\033[0m\n"
else
  printf "\033[1;31mFAILED\033[0m\n"
  echo "Expected: $expected"
  echo "Got:      $output"
  TEST_FAILURES=$((TEST_FAILURES + 1))
fi

# Exit with number of failures
if [ "$TEST_FAILURES" -eq 0 ]; then
  echo "All tests passed!"
  exit 0
else
  echo "$TEST_FAILURES tests failed."
  exit 1
fi
