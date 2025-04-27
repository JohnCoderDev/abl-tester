block-level on error undo, throw.
using classes.Tester.Errors.* from propath.

class classes.Tester.ABLAsserter:
    method public logical assertTrue(pExpression as logical):
        if not pExpression then do:
            return error new ABLAssertionError("expected expression to be 'TRUE' but is 'FALSE'").
        end.
        return true.
    end method.
    
    method public logical assertFalse(pExpression as logical):
        if pExpression then do:
            return error new ABLAssertionError("expected expression to be 'FALSE' but is 'TRUE'").
        end.
        return true.
    end method.
    
    // equal
    method public  logical assertEqual(
        pFirst as character,
        pSecond as character
    ):
        if compare(pFirst, '<>', pSecond, 'case-sensitive') then
            return error new ABLAssertionError("'" + pFirst + "' is not equal to '" + pSecond + "'").
        return true.
    end method.
    
    method public  logical assertEqual(
        pFirst as int64,
        pSecond as int64
    ):
        if pFirst <> pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertEqual(
        pFirst as decimal,
        pSecond as decimal
    ):
        if pFirst <> pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertEqual(
        pFirst as date,
        pSecond as date
    ):
        if pFirst <> pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertEqual(
        pFirst as datetime,
        pSecond as datetime
    ):
        if pFirst <> pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not equal to '"+ string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertEqual(
        pFirst as logical,
        pSecond as logical
    ):
        if pFirst <> pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    // not equal
    method public  logical assertNotEqual(
        pFirst as character,
        pSecond as character
    ):
        if compare(pFirst, '=', pSecond, 'case-sensitive') then
            return error new ABLAssertionError("'" + pFirst + "' is equal to '" + pSecond + "'").
        return true.
    end method.
    
    method public  logical assertNotEqual(
        pFirst as int64,
        pSecond as int64
    ):
        if pFirst = pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertNotEqual(
        pFirst as decimal,
        pSecond as decimal
    ):
        if pFirst = pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertNotEqual(
        pFirst as date,
        pSecond as date
    ):
        if pFirst = pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertNotEqual(
        pFirst as datetime,
        pSecond as datetime
    ):
        if pFirst = pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is equal to '"+ string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertNotEqual(
        pFirst as logical,
        pSecond as logical
    ):
        if pFirst = pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    // greater
    method public  logical assertGreaterThan(
        pFirst as int64,
        pSecond as int64
    ):
        if pFirst <= pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not greater than '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertGreaterThan(
        pFirst as decimal,
        pSecond as decimal
    ):
        if pFirst <= pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not greater than '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertGreaterThan(
        pFirst as date,
        pSecond as date
    ):
        if pFirst <= pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not greater than '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertGreaterThan(
        pFirst as datetime,
        pSecond as datetime
    ):
        if pFirst <= pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not greater than '"+ string(pSecond) + "'").
        return true.
    end method.
    
    // greater equal
    method public  logical assertGreaterEqualThan(
        pFirst as int64,
        pSecond as int64
    ):
        if pFirst < pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not greater or equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertGreaterEqualThan(
        pFirst as decimal,
        pSecond as decimal
    ):
        if pFirst < pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not greater or equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertGreaterEqualThan(
        pFirst as date,
        pSecond as date
    ):
        if pFirst < pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not greater or equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertGreaterEqualThan(
        pFirst as datetime,
        pSecond as datetime
    ):
        if pFirst < pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not greater or equal to '"+ string(pSecond) + "'").
        return true.
    end method.
    
    // lower
    method public  logical assertLowerThan(
        pFirst as int64,
        pSecond as int64
    ):
        if pFirst >= pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not lower than '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertLowerThan(
        pFirst as decimal,
        pSecond as decimal
    ):
        if pFirst >= pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not lower than '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertLowerThan(
        pFirst as date,
        pSecond as date
    ):
        if pFirst >= pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not lower than '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertLowerThan(
        pFirst as datetime,
        pSecond as datetime
    ):
        if pFirst >= pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not lower than '"+ string(pSecond) + "'").
        return true.
    end method.
    
    // lower equal
    method public  logical assertLowerEqualThan(
        pFirst as int64,
        pSecond as int64
    ):
        if pFirst > pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not lower or equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertLowerEqualThan(
        pFirst as decimal,
        pSecond as decimal
    ):
        if pFirst > pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not lower or equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertLowerEqualThan(
        pFirst as date,
        pSecond as date
    ):
        if pFirst > pSecond then
            return error new ABLAssertionError("'" + string(pFirst) + "' is not lower or equal to '" + string(pSecond) + "'").
        return true.
    end method.
    
    method public  logical assertLowerEqualThan(
        pFirst as datetime,
        pSecond as datetime
    ):
        if pFirst > pSecond then
            return error new ABLAssertionError(
                "'" + string(pFirst) + "' is not lower or equal to '"+ string(pSecond) + "'"
            ).
        return true.
    end method.
    
    // classes
    method public logical assertIsInstance(
        pObject as Progress.Lang.Object,
        pExpectedType as character
    ):
        if pObject:getClass():typeName <> pExpectedType then
            return error new ABLAssertionError(
                "object of type '" + pObject:getClass():typeName 
                + "' is not of type '" + pExpectedType + "'"
            ).
        return true.
    end method.
    
    method public logical assertThrow(
        pObject as Progress.Lang.Object,
        pMethodName as character
    ):
        do on error undo, throw:
            define variable fakeParams as Progress.Lang.ParameterList.
            assign fakeParams = new Progress.Lang.ParameterList(0).
            
            pObject:getClass():getMethod(pMethodName, fakeParams):invoke(pObject, fakeParams).
            return error new ABLAssertionError(
                "expected method '" + pMethodName + "' of class '" 
                + pObject:getClass():typeName + "'to throw an error, but it doesn't"
            ).
            catch o as Progress.Lang.Error:
                return true.
            end.
        end.
    end method.
    
    method public logical assertThrow(
        pObject  as Progress.Lang.Object,
        pMethodName as character, 
        pParams as Progress.Lang.ParameterList
    ):
        do on error undo, throw:
            pObject:getClass():getMethod(pMethodName, pParams):invoke(pObject, pParams).
            return error new ABLAssertionError(
                "expected method '" + pMethodName + "' of class '" 
                + pObject:getClass():typeName +  "' to throw an error, but it doesn't"
            ).
            catch o as Progress.Lang.Error:
                return true.
            end.
        end.
    end method.
    
    method public logical assertThrow(
        pObject as Progress.Lang.Object,
        pMethodName as character,
        pParams as Progress.Lang.ParameterList,
        pExpectedError as character
    ):
        do on error undo, throw:
            pObject:getClass():getMethod(pMethodName, pParams):invoke(pObject, pParams).
            return error new ABLAssertionError(
                "expected method '" + pMethodName + "' of class '" + 
                pObject:getClass():typeName + "' to throw an error of type '" + pExpectedError + "', but it doesn't"
            ).
            catch objError as Progress.Lang.Error:
                if objError:getClass():typeName <> pExpectedError then
                    return error new ABLAssertionError(
                        "expected method '" + pMethodName + "' of class '"  
                        + pObject:getClass():typeName + "' to throw an error of type '" + pExpectedError + "',"
                        + " but it throws an error of type '" + objError:getClass():typeName + "'"
                    ).
                return true.    
            end.
        end.
    end method.
end class.
