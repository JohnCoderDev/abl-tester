# ABL Tester
API for unit testing your code in ABL.

## QuickStart
- download the source code, compile it and put somewhere in your propath
- make a new class that inherits `classes.tester.ABLTestCase`, for example:

```
class your.path.ExampleTestCase inherits classes.tester.ABLTestCase:
  // mandatory to have even if empty 
  method public void setup():
  end method.

  method public void teardown():
  end method.
end class.
```

- make some methods for the tests cases

```
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

```
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
