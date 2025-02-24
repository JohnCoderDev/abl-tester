block-level on error undo, throw.
using progress.lang.AppError.

class ablc.third.tester.errors.ABLTestCaseWithParametersError inherits AppError:
    constructor ABLTestCaseWithParametersError():
        addMessage("the test methods of a test case must not receive any parameters", -4001).
    end constructor.
end class.
