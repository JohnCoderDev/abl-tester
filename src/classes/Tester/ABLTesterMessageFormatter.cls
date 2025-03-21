block-level on error undo, throw.

class classes.Tester.ABLTesterMessageFormatter:
    method public static void writeMessage(pMessage as character, pLevel as character):
        if session:batch-mode then do:                
            put unformatted 
                "(" + string(now, "99/99/9999 HH:MM:SS") + ") "
                + "[" + upper(pLevel) + "] " 
                +  pMessage + "~n".
        end.        
    end method.
    
    method public static void writeMessage(pMessage as character):
        writeMessage(pMessage, "info").
    end method.
end class.
