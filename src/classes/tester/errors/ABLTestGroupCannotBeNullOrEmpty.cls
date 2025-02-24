using progress.lang.AppError from propath.

class ablc.third.tester.errors.ABLTestGroupCannotBeNullOrEmpty inherits AppError:
    constructor ABLTestGroupCannotBeNullOrEmpty():
        addMessage("test group cannot be null or empty for abl test case", -4003).
    end constructor.
end class.
