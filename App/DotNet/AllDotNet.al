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
        //type(System.Data.DataSet; SQLDataSet) { }
        //type(System.Data.SqlClient.SqlDataAdapter; SQLDataAdapter) { }
    }
    assembly(System)
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        //type(System.Net.HttpWebRequest; HttpWebRequest) { }
        //type(System.Net.HttpWebResponse; HttpWebResponse) { }
    }
    assembly(mscorlib)
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        //type(System.IO.StreamWriter; StreamWriters) { }
    }
}