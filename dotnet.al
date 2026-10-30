dotnet
{
    assembly(GetNAVIPAddress)
    {
        type(GetNAVIPAddress.GetIPMac; GetIPMac) { }
    }
    assembly(System)
    {
        type(System.Net.IPAddress; IPAddress) { }
        type(System.Net.Dns; Dns) { }
        type(System.Net.IPHostEntry; IPHostEntry) { }
    }
    assembly(mscorlib)
    {
        type(System.Convert; Convert) { }
        type(System.Array; SArray) { }
        type(System.IO.MemoryStream; MemoryStream) { }
    }
}