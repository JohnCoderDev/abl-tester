block-level on error undo, throw.
using ablc.third.tester.interfaces.* from propath.

class ablc.third.tester.ABLTestResultsTableHtmlSerializer:
    method public static longchar serializeTestsTable(pTestObject as ITestObject):
        define variable htmlTable as longchar no-undo.
        assign htmlTable = '
            <div style="display: flex: flex-direction: column; gap: 20px">
            <div style="display: flex; flex-direction: row; gap: 10px">
                <div style="padding: 10px; border-radius: 5px; background-color: #E6A27D">
                    <strong>
                        Total runned: ' + string(pTestObject:totalRunned) + '
                    </strong>
                </div>
                <div style="padding: 10px; border-radius: 5px; background-color: #31FF45">
                    <strong>
                        Total success: ' + string(pTestObject:totalSuccess) 
                        + ' (' + string(round(pTestObject:totalSuccess / pTestObject:totalRunned * 100, 2)) + '%)
                    </strong>
                </div>
                <div style="padding: 10px; border-radius: 5px; background-color: #FF9089">
                    <strong>
                        Total failed: ' + string(pTestObject:totalFailed) 
                        + ' (' + string(round(pTestObject:totalFailed / pTestObject:totalRunned * 100, 2)) + '%) 
                    </strong>
                </div>
                <div style="padding: 10px; border-radius: 5px; background-color: #FF3E32">
                    <strong>
                        Total errors: ' + string(pTestObject:totalErrors) 
                        + ' (' + string(round(pTestObject:totalErrors / pTestObject:totalRunned * 100, 2)) + '%)
                    </strong>
                </div>
                <div style="padding: 10px; border-radius: 5px; background-color: #6F59FF">
                    <strong>
                        Total time: ' + string(pTestObject:totalTime) + ' ms
                    </strong>
                </div>
            </div>
        '.
         
        assign 
            htmlTable = htmlTable + serializeTableTestsResults(pTestObject:getTestsResultsTableHandle()) + '</div>'.
        return htmlTable.
    end method.
    
    method public static longchar serializeTableTestsResults(pTableHandle as handle):
        define variable serializedTable as longchar no-undo.
        define variable testResult as character no-undo.
        define variable ix as integer no-undo.

        assign serializedTable = '<table style="margin-top: 10px; border: 1px solid #CCCCCC;border-collapse: collapse;">'
        + '<tr style="font-size: 14pt; font-weight: 500">'.
        do ix = 1 to pTableHandle:default-buffer-handle:num-fields:
            assign serializedTable = serializedTable + '
                <th style="border: 1px solid #CCCCCC; padding: 10px">
                ' + pTableHandle:default-buffer-handle:buffer-field(ix):name + '
                </th>'.
        end.
        assign serializedTable = serializedTable + '</tr>'.

        define variable queryHandle as handle no-undo.
        create query queryHandle.
        queryHandle:set-buffers(pTableHandle:default-buffer-handle).
        queryHandle:query-prepare('for each ' + pTableHandle:name).
        queryHandle:query-open.
        queryHandle:get-first.

        do while not queryHandle:query-off-end:
            assign
                testResult = pTableHandle:default-buffer-handle:buffer-field("testResult"):buffer-value
                serializedTable = serializedTable + '<tr style="background-color: ' +
                (
                    if testResult = "success" then '#31FF45'
                    else if testResult = "failed" then '#FF9089'
                    else if testResult = "error" then '#FF3E32'
                    else "none"
                ) + '">'.
            do ix = 1 to pTableHandle:default-buffer-handle:num-fields:
                assign serializedTable = serializedTable + '
                    <td style="border: 1px solid #CCCCCC; padding: 10px">
                        ' + string(pTableHandle
                            :default-buffer-handle
                            :buffer-field(ix)
                            :buffer-value) + '
                    </td>
                '.
            end.
            assign serializedTable = serializedTable + "</tr>".
            queryHandle:get-next.
        end.
        assign serializedTable = serializedTable + "</table>".
        return serializedTable.
    end method.
end class.
