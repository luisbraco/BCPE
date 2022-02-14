//'System.Data, Version=2.0.0.0, 
//Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.SqlClient.SqlConnection

//SQLReaderL: DotNet  'System.Data, Version=2.0.0.0, 
//Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.SqlClient.SqlDataReader;
//SQLParameterL: DotNet  'System.Data, Version=2.0.0.0, 
//Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.SqlClient.SqlParameter;
//'System.Data, Version=2.0.0.0, Culture=neutral, 
//PublicKeyToken=b77a5c561934e089'.System.Data.SqlClient.SqlConnection

dotnet
{
    assembly(System.Data)
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';
    }
    assembly(System)
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';
    }
    assembly(mscorlib)
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';
    }
}

