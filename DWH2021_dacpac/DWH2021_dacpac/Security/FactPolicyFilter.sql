CREATE SECURITY POLICY [dbo].[FactPolicyFilter]
    ADD FILTER PREDICATE [dbo].[fn_SecurityPredicate]([JobID]) ON [dbo].[FactConvertLeadToDeal]
    WITH (STATE = ON);

