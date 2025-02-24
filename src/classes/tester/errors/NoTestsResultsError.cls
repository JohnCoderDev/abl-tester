using progress.lang.AppError.

class classes.tester.errors.NoTestsResultsError inherits AppError:
    constructor NoTestsResultsError():
        addMessage("there is not tests results", -4002).
    end constructor.
end class.
