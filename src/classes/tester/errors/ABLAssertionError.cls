block-level on error undo, throw.
using progress.lang.AppError.

class classes.tester.errors.ABLAssertionError inherits AppError:
    constructor ABLAssertionError(pMessage as character):
        addMessage(pMessage, -4000).
    end constructor.
end class.
