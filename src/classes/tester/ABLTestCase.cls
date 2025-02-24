block-level on error undo, throw.
using ablc.third.tester.* from propath.
using ablc.third.tester.errors.* from propath.
using ablc.third.tester.interfaces.* from propath.
using progress.json.ObjectModel.* from propath.

class ablc.third.tester.ABLTestCase inherits ABLAsserter abstract implements ITestObject:
    define public property totalRunned as int64 get. set.
    define public property totalSuccess as int64 get. set.
    define public property totalFailed as int64 get. set.
    define public property totalErrors as int64 get. set.
    define public property totalTime as decimal get. set.
    
    define private temp-table testsResults
        field className as character
        field methodName as character
        field testResult as character
        field testMessage as character
        field lastErrorCode as integer initial 0
        field timestampStart as datetime
        field timestampEnd as datetime
        field totalTime as decimal.
    
    method public abstract void setup().
    method public abstract void teardown().
    
    method public ABLTestCase runTests():
        return runTests("test*").
    end method.
    
    method public ABLTestCase runTests(pPattern as character):
        clearTestsResults().
        define variable currentMethod as progress.reflect.method.
        define variable methods as progress.reflect.method extent.
        define variable ix as integer no-undo.
        
        assign methods = this-object:getClass():getMethods().
        
        do ix = 1 to extent(methods) on error undo:
            setup().
            assign currentMethod = methods[ix].
            
            if currentMethod:name matches pPattern then do:
                create testsResults.
               
                assign
                    totalRunned = totalRunned + 1
                    testsResults.className = currentMethod:originatingClass:typeName
                    testsResults.methodName = currentMethod:name
                    testsResults.timestampStart = now.
                    
                if currentMethod:numParameters > 0 then do:
                    return error new ABLTestCaseWithParametersError().
                end.
                
                currentMethod:invoke(this-object, new progress.lang.parameterList(0)).
                
                assign
                    totalSuccess = totalSuccess + 1
                    testsResults.testResult = "success"
                    testsResults.testMessage = "ok".
            end.
           
            catch objAssertionError as ABLAssertionError:
                assign
                    totalFailed = totalFailed + 1
                    testsResults.testResult = "failed"
                    testsResults.testMessage = objAssertionError:getMessage(1)
                    testsResults.lastErrorCode = objAssertionError:getMessageNum(1).
            end catch.
            
            catch objError as progress.lang.error:
                define variable iy as integer no-undo.
                
                assign testsResults.testResult = "error".
                do iy = 1 to objError:numMessages: 
                    assign
                        totalErrors = totalErrors + 1
                        testsResults.testMessage = testsResults.testMessage + ";" + objError:getMessage(iy)
                        testsResults.lastErrorCode = objError:getMessageNum(iy).
                end.
            end catch.
            
            finally:
                if currentMethod:name matches pPattern then do:
                    assign
                        testsResults.timestampEnd = now
                        testsResults.totalTime = testsResults.timestampEnd - testsResults.timestampStart
                        totalTime = totalTime + testsResults.totalTime.
                end.
                teardown().
            end finally.
        end.
        return this-object.
    end method.
    
    method public ABLTestCase clearTestsResults():
        empty temp-table testsResults.
        assign
            totalRunned = 0
            totalSuccess = 0
            totalFailed = 0
            totalErrors = 0
            totalTime = 0.
        return this-object.
    end method.
    
    method public JsonObject getTestsResultsObject():
        if not temp-table testsResults:has-records then 
            return error new NoTestsResultsError().
            
        define variable resultJsonArray as JsonArray no-undo.
        define variable testsJsonObject as JsonObject no-undo.
        
        assign 
            resultJsonArray = new JsonArray()
            testsJsonObject = new JsonObject().
        
        temp-table testsResults:write-json("JsonArray", resultJsonArray, true, ?, false, true).
        
        testsJsonObject:add("meta", new JsonObject()).
        testsJsonObject:add("results", resultJsonArray).
        testsJsonObject:getJsonObject("meta"):add("runned", totalRunned).
        testsJsonObject:getJsonObject("meta"):add("success", totalSuccess).
        testsJsonObject:getJsonObject("meta"):add("failed", totalFailed).
        testsJsonObject:getJsonObject("meta"):add("errors", totalErrors).
        testsJsonObject:getJsonObject("meta"):add("successRating", totalSuccess / totalRunned).
        testsJsonObject:getJsonObject("meta"):add("failedRating", totalFailed / totalRunned).
        testsJsonObject:getJsonObject("meta"):add("errorsRating", totalErrors / totalRunned).
        testsJsonObject:getJsonObject("meta"):add("totalTime", totalTime).
        
        return testsJsonObject.
    end method.
    
    method public longchar getTableHtml():
        return ABLTestResultsTableHtmlSerializer:serializeTestsTable(this-object).
    end method.
    
    method public handle getTestsResultsTableHandle():
        return temp-table testsResults:handle.
    end method.
    
    method public void showResultsTable():
        for each testsResults:
            display 
                testsResults
                with scrollable.
        end.
    end method.
end class.
