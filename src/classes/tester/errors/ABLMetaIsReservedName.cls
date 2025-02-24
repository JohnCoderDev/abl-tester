using progress.lang.AppError from propath.

class ablc.third.tester.errors.ABLMetaIsReservedName inherits AppError:
    constructor ABLMetaIsReservedName():
        addMessage("name 'meta' is a reserved name", -4004).
    end constructor.
end class.
