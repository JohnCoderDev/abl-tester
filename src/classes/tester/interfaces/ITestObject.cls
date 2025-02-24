interface ablc.third.tester.interfaces.ITestObject:
    define public property totalRunned as int64 get. set.
    define public property totalSuccess as int64 get. set.
    define public property totalFailed as int64 get. set.
    define public property totalErrors as int64 get. set.
    define public property totalTime as decimal get. set.
    
    define temp-table testsResults
        field className as character
        field methodName as character
        field testResult as character
        field testMessage as character
        field lastErrorCode as integer initial 0
        field timestampStart as datetime
        field timestampEnd as datetime
        field totalTime as decimal.
        
    method public handle getTestsResultsTableHandle().    
end interface.
