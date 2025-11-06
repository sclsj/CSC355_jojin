#!/usr/bin/env bash

# gpl project testing script (enhanced failure diffs)
# Works for p3–p7. Prints diffs for stdout/stderr on failures.

set -u

test_dir=tests
result_dir=results

# Prefer colordiff if available
DIFF="diff"
if command -v colordiff >/dev/null 2>&1; then
  DIFF="colordiff"
fi

# Print a labeled unified diff; if expected file missing, diff against /dev/null
print_diff () {
  local label="$1" actual="$2" expected="$3"
  local exp_path="$expected"
  if ! [ -f "$expected" ]; then
    exp_path="/dev/null"
  fi
  echo "──────── ${label} diff ────────"
  # --label makes the headers readable
  $DIFF -u --label "actual:$actual" --label "expected:$expected" "$actual" "$exp_path" || true
  echo "────────────────────────────────"
}

if ! [ -f ./gpl ] ; then
  echo "There is no gpl executable in this directory. gt is giving up."
  exit 1
fi

if ! [ -d "$test_dir" ] ; then
  echo "There is not a test subdirectory in this directory. gt is giving up."
  exit 1
fi

passed=0
failed=0
previously_passed=0

all_test_files=$test_dir/t[0-9][0-9][0-9].gpl

# Arg handling
if [[ $# -eq 1 && $1 == "-all" ]]; then
  rm -rf "$result_dir"
elif [[ $# -eq 1 ]]; then
  if [[ $1 -lt 10 ]]; then
    test_number=00$1
  elif [[ $1 -lt 100 ]]; then
    test_number=0$1
  else
    test_number=$1
  fi
  all_test_files=$test_dir/t$test_number.gpl
  rm -f "$result_dir/t$test_number.passed"
  if ! [ -f "$all_test_files" ] ; then
    echo "<$all_test_files> does not exist. Giving up."
    exit 1
  fi
fi

mkdir "$result_dir" 2>/dev/null

for gpl_test_file in $all_test_files ; do
  test_name=${gpl_test_file%.gpl}
  test_name=${test_name##*/}

  if [ "$test_name" = "t[0-9][0-9][0-9]" ] ; then
    echo "The test directory does not contain any tests. gt is giving up"
    exit 1
  fi

  if [ -f "$result_dir/$test_name.passed" ] ; then
    (( previously_passed++ ))
  else
    if [ -f "$test_dir/$test_name.jpg" ] ; then
      echo "no pixel file created" > "$result_dir/$test_name.mypixels"
      dump_pixel_flag="-dump_pixels $result_dir/$test_name.mypixels"
    else
      dump_pixel_flag=""
    fi

    if [ -f "$test_dir/$test_name.keypresses" ] ; then
      ./gpl -stdin -s 42 $dump_pixel_flag "$gpl_test_file" \
        < "$test_dir/$test_name.keypresses" \
        > "$result_dir/$test_name.myout" \
        2> "$result_dir/$test_name.myerr"
    else
      ./gpl -s 42 $dump_pixel_flag "$gpl_test_file" \
        > "$result_dir/$test_name.myout" \
        2> "$result_dir/$test_name.myerr"
    fi

    # Compare outputs
    if diff "$result_dir/$test_name.myout" "$test_dir/$test_name.out" >& /dev/null ; then
      correct_stdout=true
    else
      correct_stdout=false
    fi

    if diff "$result_dir/$test_name.myerr" "$test_dir/$test_name.err" >& /dev/null ; then
      correct_stderr=true
    else
      correct_stderr=false
    fi

    if [ -f "$test_dir/$test_name.jpg" ] ; then
      if diff "$result_dir/$test_name.mypixels" "$test_dir/$test_name.pixels" >& /dev/null ; then
        correct_pixels=true
      elif [ -f "$test_dir/$test_name.pixels_option1" ] && diff "$result_dir/$test_name.mypixels" "$test_dir/$test_name.pixels_option1" >& /dev/null ; then
        correct_pixels=true
      elif [ -f "$test_dir/$test_name.pixels_option2" ] && diff "$result_dir/$test_name.mypixels" "$test_dir/$test_name.pixels_option2" >& /dev/null ; then
        correct_pixels=true
      else
        correct_pixels=false
      fi
    else
      correct_pixels=true
    fi

    if $correct_stdout && $correct_stderr && $correct_pixels ; then
      (( passed++ ))
      echo "Passed $test_name"
      : > "$result_dir/$test_name.passed"
    else
      (( failed++ ))
      echo "Failed $test_name:$($correct_stdout || echo ' <stdout incorrect>')$($correct_stderr || echo ' <stderr incorrect>')$($correct_pixels || echo ' <pixels incorrect>')"

      # Show diffs to help debugging
      if ! $correct_stdout ; then
        print_diff "stdout ($test_name)" "$result_dir/$test_name.myout" "$test_dir/$test_name.out"
      fi
      if ! $correct_stderr ; then
        print_diff "stderr ($test_name)" "$result_dir/$test_name.myerr" "$test_dir/$test_name.err"
      fi
      # Optional: show pixels diff when GT_SHOW_PIXELS=1 in env
      if ! $correct_pixels && [ "${GT_SHOW_PIXELS:-0}" = "1" ]; then
        # Prefer the canonical .pixels if it exists, else pick the first option present
        exp_pix=""
        if [ -f "$test_dir/$test_name.pixels" ]; then
          exp_pix="$test_dir/$test_name.pixels"
        elif [ -f "$test_dir/$test_name.pixels_option1" ]; then
          exp_pix="$test_dir/$test_name.pixels_option1"
        elif [ -f "$test_dir/$test_name.pixels_option2" ]; then
          exp_pix="$test_dir/$test_name.pixels_option2"
        fi
        if [ -n "$exp_pix" ]; then
          print_diff "pixels ($test_name)" "$result_dir/$test_name.mypixels" "$exp_pix"
        fi
      fi
    fi
  fi
done

total=$((passed + failed))
echo "Passed $passed out of $total tests."
echo "Failed $failed out of $total tests."

if [ "$previously_passed" -ne "0" ] ; then
  echo "  $previously_passed tests were skipped (passed on previous run)"
  echo "    \"\$ gt -all\" to run all tests (recommended before you turn in assignment)"
  echo "    \"\$ gt 42\" to run test t042.gpl"
fi
