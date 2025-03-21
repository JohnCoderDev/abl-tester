using Progress.Lang.AppError from propath.

class classes.Tester.Errors.ABLMetaIsReservedName inherits AppError:
    constructor ABLMetaIsReservedName():
        addMessage("name 'meta' is a reserved name", -4004).
    end constructor.
end class.
