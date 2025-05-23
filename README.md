# ABL Tester
API for unit testing your code in ABL.

## QuickStart
- download the source code, compile it and put somewhere in your propath
- make a new class that inherits `classes.tester.ABLTestCase`, for example:

```progress
class your.path.ExampleTestCase inherits classes.tester.ABLTestCase:
  // mandatory to have even if empty 
  method public override void setup():
  end method.

  method public override void teardown():
  end method.
end class.
```

- make some methods for the tests cases

```progress
class your.path.ExampleTestCase inherits classes.tester.ABLTestCase:
  ...

  // name must start with "test"
  method public void testFirst():
    assertTrue(1 = 2). // fails
  end method.

  method public void testSecond():
    assertEqual(1, 1). // succeeds
  end method.

  // ignored because does not start with "test"
  method public void thirdTest():
  end method.
  ...
end class.
```

- in a `.p` file, make an instance of the `ABLTestCollection` class and run the tests

```progress
// run-tests.p
define variable testRunner as classes.tester.ABLTestCollection.

assign testRunner = new ABLTestCollection().

testRunner
  :addTest("your.path.ExampleTestCase")
  // :addTest(new AnotherTestCase(), "another-group")
  // :addTest(new OneMoreTestCase())
  // ...
  // you can put as many tests as you want
  :runTests()
  :writeFile("C:\temp\tests-results.html"). // writes the results to a html table
```

## Using the CLI (Windows)
In order to use the CLI run the script [install-ablt](./src/cli/install-ablt.bat) as administrator.
Check if it's installed running the following command:

```
> ablt -h
```
