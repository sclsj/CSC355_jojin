import os, sys, re
import subprocess
import difflib
import shutil

os.system("make")

TEST_DIR = "tests"

TEST_FILES = [
        't001', 't001', 't002', 't003', 't004', 't005', 't006', 't007',
        't008', 't009', 't010', 't011', 't012', 't020', 't021', 't022',
        't023', 't024']

NUMBER_OF_TESTS = 18

def tests():

    assert os.path.exists("./parser"), f"ERROR: parser executable misg."

    if os.path.exists("./results"):
        shutil.rmtree("./results")

    os.mkdir("./results")

    # Collect user results.
    for test_file in TEST_FILES:
        path = f"{TEST_DIR}/{test_file}.in"
        output = subprocess.run(["./parser", path], capture_output=True, text=True)

        with open(f"./results/{test_file}.myout", "w") as f:
            f.write(output.stdout)

        with open(f"./results/{test_file}.myerr", "w") as f:
            f.write(output.stderr)

    passed_tests = 0
    
    # Compare with the expected output results.
    for test_file in TEST_FILES:
        myout = None
        myerr = None

        expectedout = None
        expectederr = None

        with open(f"./results/{test_file}.myout", "r") as f:
            myout = f.read()
        with open(f"./results/{test_file}.myerr", "r") as f:
            myerr = f.read()

        assert myout != None, f"ERROR: myout is empty."
        assert myerr != None, f"ERROR: myerr is empty."

        with open(f"./tests/{test_file}.out", "r") as f:
            expectedout = f.read()
        with open(f"./tests/{test_file}.err", "r") as f:
            expectederr = f.read()

        assert myout != None, f"ERROR: expectedout is empty."
        assert myerr != None, f"ERROR: expectederr is empty."

        if myout == expectedout and myerr == expectederr:
            print (f"{test_file}...........Pass (stdout pass; stderr pass)")
            passed_tests += 1
        elif myout == expectedout and myerr != expectederr:
            print (f"{test_file}...........Fail (stdout pass; stderr fail)")
        elif myout != expectedout and myerr == expectederr:
            print (f"{test_file}...........Fail (stdout fail; stderr pass)")
        else:
            assert (
                myout != expectedout and 
                myerr != expectederr
            ), f"ERROR: myout != expectedout and myerr != expectederr failed."
            print (f"{test_file}...........Fail (stdout fail; stderr fail)")

    print (f"{passed_tests} test(s) passed out of {NUMBER_OF_TESTS}")

if __name__ == "__main__":
    tests()
