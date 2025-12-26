using Microsoft.Data.SqlClient;
using System.Data;

namespace WebKitapyurdu.Data
{
    public static class DataReaderExtensions
    {
        public static string GetString(this SqlDataReader reader, string name)
        {
            int ordinal = reader.GetOrdinal(name);
            if (reader.IsDBNull(ordinal)) return string.Empty; // Or null? The code using it might expect a string.
            // Existing code does reader.GetString("Title"). Standard GetString throws if null.
            // If the code expects standard behavior but by name:
            return reader.GetString(ordinal);
        }

        public static int GetInt32(this SqlDataReader reader, string name)
        {
            return reader.GetInt32(reader.GetOrdinal(name));
        }

        public static decimal GetDecimal(this SqlDataReader reader, string name)
        {
            return reader.GetDecimal(reader.GetOrdinal(name));
        }

        public static double GetDouble(this SqlDataReader reader, string name)
        {
            return reader.GetDouble(reader.GetOrdinal(name));
        }

        public static bool GetBoolean(this SqlDataReader reader, string name)
        {
            return reader.GetBoolean(reader.GetOrdinal(name));
        }

        public static DateTime GetDateTime(this SqlDataReader reader, string name)
        {
            return reader.GetDateTime(reader.GetOrdinal(name));
        }

        public static bool IsDBNull(this SqlDataReader reader, string name)
        {
            try 
            {
                int ordinal = reader.GetOrdinal(name);
                return reader.IsDBNull(ordinal);
            }
            catch (IndexOutOfRangeException)
            {
                // Column doesn't exist? Treat as null/ignore? 
                // Better to let it throw or handle gracefully if we want optional columns.
                throw;
            }
        }
    }
}
