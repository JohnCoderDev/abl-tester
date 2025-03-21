using Progress.Lang.AppError.

class classes.Tester.Errors.NoTestsResultsError inherits AppError:
    constructor NoTestsResultsError():
        addMessage("there is not tests results", -4002).
    end constructor.
end class.
