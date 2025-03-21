block-level on error undo, throw.

using Progress.Json.ObjectModel.* from propath.
using classes.PathTester.* from propath.
using classes.Json.* from propath.
using classes.Tester.* from propath.

define variable CLIParameters as character no-undo.
define variable testerParameters as character no-undo.
define variable testerTestCaseFile as character no-undo.
define variable testerTestCaseName as character no-undo.
define variable testerDiscoverDir as character no-undo.
define variable testerDiscoverPattern as character no-undo.
define variable testerLogFile as character no-undo.
define variable testerHtmlFilePath as character no-undo.
define variable testerJsonFilePath as character no-undo.
define variable additionalProcedures as character no-undo.
define variable pathTester as PathTester no-undo.

assign 
    CLIParameters = session:parameter
    pathTester = new PathTester()
    testerParameters = entry(1, CLIParameters)
    testerTestCaseFile = entry(1, testerParameters, ";")
    testerTestCaseName = replace(entry(2, testerParameters, ";"), if opsys = "win32" then "\" else "/", ".")
    testerDiscoverDir = entry(3, testerParameters, ";")
    testerDiscoverPattern = entry(4, testerParameters, ";")
    testerLogFile = entry(5, testerParameters, ";")
    testerHtmlFilePath = entry(6, testerParameters, ";")
    testerJsonFilePath = entry(7, testerParameters, ";")
    additionalProcedures = substring(CLIParameters, index(CLIParameters, ",") + 1).

output to value(testerLogFile).

function discoverTestFiles returns logical(pTestCollection as ABLTestCollection, pPrefix as character, pBasePath as character):
    define variable nameOfPath as character no-undo.
    define variable testName as character no-undo.
    define variable currentPath as character no-undo.
        
    pathTester:setPath(pBasePath).
    input from os-dir(pathTester:getFullPath()).
        repeat:
            import nameOfPath.
            if nameOfPath = "." or nameOfPath = ".." then next.
            
            pathTester:setPath(pBasePath + "/" + nameOfPath).
            
            if nameOfPath matches testerDiscoverPattern and pathTester:isFile() then do:
                assign testName = pPrefix + entry(1, nameOfPath, ".").
                
                pTestCollection:addTest(testName).
                ABLTesterMessageFormatter:writeMessage(
                    "added test `" + testName + "` to the collection"
                ).    
            end.
            else if pathTester:isDir() then do:
                discoverTestFiles(pTestCollection, pPrefix + nameOfPath + ".", pBasePath + "/" + nameOfPath).
            end.
        end.    
    input close.
    return true.
end.

if testerDiscoverDir <> "" then do:
    if not propath matches testerDiscoverDir + ",*" then do:
        assign propath = testerDiscoverDir + ",*" + propath.    
    end.
    ABLTesterMessageFormatter:writeMessage(
        "added `" + testerDiscoverDir + "` to the propath"
    ).
end.
else do:
    if not propath matches ".;*" then do:
        assign propath = ".;" + propath.
    end.
    ABLTesterMessageFormatter:writeMessage(
        "added `.` to the propath"
    ).
end.


if testerTestCaseFile <> "" then do:
    if not testerTestCaseFile matches "*.cls" then do:
        assign testerTestCaseFile = testerTestCaseFile + ".cls".
    end.
    
    pathTester:setPath(testerTestCaseFile).
    if not pathTester:pathExists() or not pathTester:isFile() then do:
        ABLTesterMessageFormatter:writeMessage(
            "test file `" + pathTester:getFullPath() + "` was not found",
            'error'
        ).
        output close.
        quit.
    end.
end.

if testerDiscoverDir <> "" then do:
    pathTester:setPath(testerDiscoverDir).
    if not pathTester:pathExists() or not pathTester:isDir() then do:
        ABLTesterMessageFormatter:writeMessage(
            "folder to discover `" + pathTester:getFullPath() + "` was not found",
            'error'
        ).
        output close.
        quit.
    end.
end.

if additionalProcedures <> "" then do:
    define variable idx as integer no-undo.
    do idx = 1 to num-entries(additionalProcedures):
        pathTester:setPath(entry(idx, additionalProcedures)).
        
        if pathTester:pathExists() and pathTester:isFile() then do:
            ABLTesterMessageFormatter:writeMessage(
                "running before script `" + pathTester:getFullPath() + "`"
            ).    
            run value(pathTester:getFullPath()).
        end.
        else do:
            ABLTesterMessageFormatter:writeMessage(
                "procedure `" + entry(idx, additionalProcedures) + "` not found",
                'warning'
            ).
        end.
    end.
end.

do on error undo, leave:
    define variable testCollection as ABLTestCollection.
    assign testCollection = new ABLTestCollection().
    
    if testerTestCaseFile <> "" then do:    
        testCollection:addTest(testerTestCaseName).
        ABLTesterMessageFormatter:writeMessage(
            "added test case `" + testerTestCaseFile + "`"
        ).
    end.
    else do:
        ABLTesterMessageFormatter:writeMessage(
            "discovering files"
        ).
        discoverTestFiles(testCollection, "", testerDiscoverDir).
    end.
    
    ABLTesterMessageFormatter:writeMessage(
        "running tests"
    ).
    
    testCollection:runTests().
    
    if testerHtmlFilePath <> "" then do:
        testCollection:writeFile(testerHtmlFilePath).
        ABLTesterMessageFormatter:writeMessage(
            "written html file `" + testerHtmlFilePath + "`"
        ).
    end.
    
    if testerJsonFilePath <> "" then do:
        testCollection:getTestsResultsObject():writeFile(testerJsonFilePath, true).
        ABLTesterMessageFormatter:writeMessage(
            "written json file `" + testerJsonFilePath + "`"
        ).
    end.
    
    if testerHtmlFilePath = "" and testerJsonFilePath = "" then do:
        ABLTesterMessageFormatter:writeMessage(
            "the results of the tests are not being redirected to anywhere",
            "warning"
        ).
    end.
    
    catch objError as Progress.Lang.Error:
        do idx = 1 to objError:numMessages:
            ABLTesterMessageFormatter:writeMessage(
                objError:getMessage(idx),
                'error'
            ).
        end.
    end catch.
end.

output close.
quit.
