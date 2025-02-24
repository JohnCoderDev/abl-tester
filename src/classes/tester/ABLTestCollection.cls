block-level on error undo, throw.
using ablc.third.tester.* from propath.
using ablc.third.tester.errors.* from propath.
using ablc.third.tester.interfaces.* from propath.
using progress.json.ObjectModel.* from propath.

class ablc.third.tester.ABLTestCollection implements ITestObject:
    define public property totalRunned as int64 get. set.
    define public property totalSuccess as int64 get. set.
    define public property totalFailed as int64 get. set.
    define public property totalErrors as int64 get. set.
    define public property totalTime as decimal get. set.
    
    define private temp-table testsResults
        field testGroup as character initial ?
        field className as character
        field methodName as character
        field testResult as character
        field testMessage as character
        field lastErrorCode as integer initial 0
        field timestampStart as datetime
        field timestampEnd as datetime
        field totalTime as decimal.
        
    define private temp-table tests
        field testGroup as character
        field testClass as character
        field testObject as progress.lang.object
        index idxUnique as primary unique testGroup testClass.
    
    method public ABLTestCollection addTest(pObject as progress.lang.object):
        return addTest(pObject, "default").
    end method.
    
    method public ABLTestCollection addTest(pObject as progress.lang.object, pGroup as character):
        if pGroup = ? or pGroup = "" then do:
            return error new ABLTestGroupCannotBeNullOrEmpty().
        end.
        
        if pGroup = "meta" then do:
            return error new ABLMetaIsReservedName().
        end.
        
        create tests.
        assign
            tests.testGroup = pGroup
            tests.testClass = pObject:getClass():typeName
            tests.testObject = pObject.
        return this-object.    
    end method.
    
    method public ABLTestCollection addTest(pName as character):
        return addTest(pName, "default").
    end method.
    
    method public ABLTestCollection addTest(pName as character, pGroup as character):
        create tests.
        assign 
            tests.testGroup = pGroup
            tests.testClass = pName
            tests.testObject = progress.lang.class:getClass(pName):new().
        return this-object.    
    end method.
    
    method public ABLTestCollection clearTestsObject():
        empty temp-table tests.
        clearTestsResults().
        return this-object.
    end method.
    
    method public ABLTestCollection runTests():
        return runTests("test*").
    end method.
    
    method public ABLTestCollection runTests(pPattern as character):
        return runTests(pPattern, "*").
    end method.
    
    method public ABLTestCollection runTests(pPattern as character, pGroup as character):
        define variable test as ABLTestCase.
        
        for each tests where tests.testGroup matches pGroup:
            assign test = cast(tests.testObject, ABLTestCase).
            test:runTests(pPattern).
            temp-table testsResults:copy-temp-table(test:getTestsResultsTableHandle(), true, false, true).
            
            assign
                totalRunned = totalRunned + test:totalRunned
                totalSuccess = totalSuccess + test:totalSuccess
                totalFailed = totalFailed + test:totalFailed
                totalErrors = totalErrors + test:totalErrors
                totalTime = totalTime + test:totalTime.
                
            for each testsResults where testsResults.testGroup = ?:
                assign testsResults.testGroup = tests.testGroup.
            end.
        end.
        return this-object.
    end method.
    
    method public handle getTestsResultsTableHandle():
        return temp-table testsResults:handle.
    end method.
    
    method public JsonObject getTestsResultsObject():
        return getTestsResultsObject(false).
    end method.
    
    method public JsonObject getTestsResultsObject(pGrouped as logical):
        if not temp-table testsResults:has-records then 
            return error new NoTestsResultsError().
        
        define variable resultsJson as JsonObject no-undo.
        define variable resultsJsonArray as JsonArray no-undo.
        define variable testsJsonObject as JsonObject no-undo.
        
        assign 
            resultsJsonArray = new JsonArray()
            testsJsonObject = new JsonObject().
        
        temp-table testsResults:write-json("JsonArray", resultsJsonArray, true, ?, false, true).
        
        testsJsonObject:add("meta", new JsonObject()).
        testsJsonObject:getJsonObject("meta"):add("runned", totalRunned).
        testsJsonObject:getJsonObject("meta"):add("success", totalSuccess).
        testsJsonObject:getJsonObject("meta"):add("failed", totalFailed).
        testsJsonObject:getJsonObject("meta"):add("errors", totalErrors).
        testsJsonObject:getJsonObject("meta"):add("successRating", totalSuccess / totalRunned).
        testsJsonObject:getJsonObject("meta"):add("failedRating", totalFailed / totalRunned).
        testsJsonObject:getJsonObject("meta"):add("errorsRating", totalErrors / totalRunned).
        testsJsonObject:getJsonObject("meta"):add("totalTime", totalTime).
        
        if pGrouped then do:
            define variable resultsObject as JsonObject no-undo.
            define variable groupName as character no-undo.
            define variable ix as integer no-undo.
            
            assign resultsObject = new JsonObject().
            
            do ix = 1 to resultsJsonArray:length:
                assign groupName = resultsJsonArray:getJsonObject(ix):getCharacter("testGroup").
                
                if not resultsObject:has(groupName) then do:
                    resultsObject:add(groupName, new JsonArray()).
                end.
                
                resultsObject:getJsonArray(groupName):add(resultsJsonArray:getJsonObject(ix)).
            end.
            testsJsonObject:add("results", resultsObject).
        end.
        else do:
           testsJsonObject:add("results", resultsJsonArray). 
        end.
        
        return testsJsonObject.
    end method.
    
    method public void showTestsResultsTable():
        showTestsResultsTable(false).
    end method.
    
    method public void showTestsResultsTable(pOnlyFails as logical):
        for each testsResults
            where testsResults.testResult <> (if pOnlyFails then "success" else ""):
            display 
                testsResults 
                with scrollable.
        end.
    end method.
    
    method public longchar getTableHtml():
        return ABLTestResultsTableHtmlSerializer:serializeTestsTable(this-object).
    end method.
    
    method public logical writeFile():
        writeFile(session:temp-directory + "test-collection-result.html").
    end method.
    
    method public logical writeFile(pPath as character):
        writeFile(pPath, false).
    end method.
    
    method public logical writeFile(pPath as character, pOnlyFails as logical):
        do on error undo:
            if pOnlyFails then do:
                for each testsResults where testsResults.testResult = 'success':
                    delete testsResults.
                end.
            end.
            define variable tableHtml as longchar no-undo.
            assign tableHtml = getTableHtml().
            if not pPath matches "*.html" then assign pPath = pPath + ".html".
            copy-lob from tableHtml to file pPath.
            return true.
            
            catch objError as progress.lang.error:
                return false.
            end catch.
        end.
    end method.
    
    method public ABLTestCollection clearTestsResults():
        empty temp-table testsResults.
        assign
            totalRunned = 0
            totalSuccess = 0
            totalFailed = 0
            totalErrors = 0
            totalTime = 0.
        return this-object.
    end method.
end class.
