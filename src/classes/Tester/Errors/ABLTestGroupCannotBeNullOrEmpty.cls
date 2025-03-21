using Progress.Lang.AppError from propath.

class classes.Tester.Errors.ABLTestGroupCannotBeNullOrEmpty inherits AppError:
    constructor ABLTestGroupCannotBeNullOrEmpty():
        addMessage("test group cannot be null or empty for abl test case", -4003).
    end constructor.
end class.
