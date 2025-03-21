block-level on error undo, throw.
using Progress.Lang.AppError.

class classes.Tester.Errors.ABLTestCaseWithParametersError inherits AppError:
    constructor ABLTestCaseWithParametersError():
        addMessage("the test methods of a test case must not receive any parameters", -4001).
    end constructor.
end class.
