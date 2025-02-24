using progress.lang.AppError.

class ablc.third.tester.errors.NoTestsResultsError inherits AppError:
    constructor NoTestsResultsError():
        addMessage("there is not tests results", -4002).
    end constructor.
end class.
