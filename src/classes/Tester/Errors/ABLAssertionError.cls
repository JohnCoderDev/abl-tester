block-level on error undo, throw.
using Progress.Lang.AppError.

class classes.Tester.Errors.ABLAssertionError inherits AppError:
    constructor ABLAssertionError(pMessage as character):
        addMessage(pMessage, -4000).
    end constructor.
end class.
