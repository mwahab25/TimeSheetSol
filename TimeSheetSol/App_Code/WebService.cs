using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;

/// <summary>
/// Summary description for WebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService {

    //SqlConnection con = new SqlConnection("Data Source=.;Initial Catalog=TimeSheet;Integrated Security=True");
    SqlConnection con = new SqlConnection(@"Data Source=.\SQLEXPRESS;AttachDbFilename='|DataDirectory|\TimeSheetDB.mdf';Integrated Security=True;User Instance=True");
    public WebService () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

    [WebMethod]
    public int GetActivityID(string activityname)
    {
        con.Open();

        SqlCommand cmd = new SqlCommand("select ActivityID from Activities where ActivityName = '" + activityname + "'", con);
        SqlDataReader reader;
        reader = cmd.ExecuteReader();

        int res;
        if (reader.Read())
        {
            res = reader.GetInt32(0);
        }
        else
        {
            res = 0;
        }
        con.Close();
        return res;

    }

    [WebMethod]
    public int GetActivityHours(int ActivityID, int Daynum, int Monthnum, int Yearnum)
    {
        con.Open();

        SqlCommand cmd = new SqlCommand("select Activityhours from Employee where ActivityID='" + ActivityID + "' and [Day]='" + Daynum + "' and [Month]='" + Monthnum + "' and [Year]='" + Yearnum + "'", con);
        SqlDataReader reader;
        reader = cmd.ExecuteReader();

        int res;
        if (reader.Read())
        {
            res = reader.GetInt32(0);
        }
        else
        {
            res = 0;
        }
        con.Close();
        return res;

    }

    [WebMethod]
    public List<string> GetActivities()
    {
        con.Open();

        SqlCommand cmd = new SqlCommand("select * from Activities", con);
        SqlDataReader reader;

        List<string> activities = new List<string>();

        reader = cmd.ExecuteReader();

        string res;
        while (reader.Read())
        {
            res = reader["ActivityName"].ToString();
            activities.Add(res);
        }
        reader.Close();
        con.Close();
        return activities;
    }

    [WebMethod]
    public string InsertEmpDetails(int ActivityID, int Daynum, int Monthnum, int Yearnum, int Activitieshours)
    {
        //int actid = GetActivityID(ActivityName);
        //int max = GetSumActivHrs();

        int cabd = CheckActivitiesByDate(Daynum, Monthnum, Yearnum);

        if (cabd > 0)
        {
            //update
            string Message;
            con.Open();

            SqlCommand cmd = new SqlCommand("update Employee set Activityhours=@Activityhours where ActivityID=@ActivityID and [Day]=@Day and [Month]=@Month and [Year]=@Year", con);

            cmd.Parameters.Add("@ActivityID", SqlDbType.Int);
            cmd.Parameters["@ActivityID"].Value = ActivityID;

            cmd.Parameters.Add("@Day", SqlDbType.Int);
            cmd.Parameters["@Day"].Value = Daynum;

            cmd.Parameters.Add("@Month", SqlDbType.Int);
            cmd.Parameters["@Month"].Value = Monthnum;

            cmd.Parameters.Add("@Year", SqlDbType.Int);
            cmd.Parameters["@Year"].Value = Yearnum;

            cmd.Parameters.Add("@Activityhours", SqlDbType.Int);
            cmd.Parameters["@Activityhours"].Value = Activitieshours;

            int result = cmd.ExecuteNonQuery();
            if (result == 1)
            {
                Message = "updated Successfully" + " " + ActivityID;
            }
            else
            {
                Message = " Details not updated successfully";
            }
            con.Close();
            return Message;
        }
        else
        {



            string Message;

            con.Open();


            SqlCommand cmd = new SqlCommand("insert into Employee(EmployeeID,ActivityID,Day,Month,Year,Activityhours) values('1',@ActivityID,@Day,@Month,@Year,@Activityhours)", con);

            cmd.Parameters.Add("@ActivityID", SqlDbType.Int);
            cmd.Parameters["@ActivityID"].Value = ActivityID;

            cmd.Parameters.Add("@Day", SqlDbType.Int);
            cmd.Parameters["@Day"].Value = Daynum;

            cmd.Parameters.Add("@Month", SqlDbType.Int);
            cmd.Parameters["@Month"].Value = Monthnum;

            cmd.Parameters.Add("@Year", SqlDbType.Int);
            cmd.Parameters["@Year"].Value = Yearnum;

            cmd.Parameters.Add("@Activityhours", SqlDbType.Int);
            cmd.Parameters["@Activityhours"].Value = Activitieshours;

            int result = cmd.ExecuteNonQuery();
            if (result == 1)
            {
                Message = "insert Successfully" + " " + ActivityID;
            }
            else
            {
                Message = " Details not inserted successfully";
            }
            con.Close();
            return Message;
        }
    }

    [WebMethod]
    public string UpdateEmpDetails(int ActivityID, int Daynum, int Monthnum, int Yearnum, int Activitieshours)
    {

        string Message;
        con.Open();

        SqlCommand cmd = new SqlCommand("update Employee set Activityhours=@Activityhours where ActivityID=@ActivityID and [Day]=@Day and [Month]=@Month and [Year]=@Year", con);

        cmd.Parameters.Add("@ActivityID", SqlDbType.Int);
        cmd.Parameters["@ActivityID"].Value = ActivityID;

        cmd.Parameters.Add("@Day", SqlDbType.Int);
        cmd.Parameters["@Day"].Value = Daynum;

        cmd.Parameters.Add("@Month", SqlDbType.Int);
        cmd.Parameters["@Month"].Value = Monthnum;

        cmd.Parameters.Add("@Year", SqlDbType.Int);
        cmd.Parameters["@Year"].Value = Yearnum;

        cmd.Parameters.Add("@Activityhours", SqlDbType.Int);
        cmd.Parameters["@Activityhours"].Value = Activitieshours;

        int result = cmd.ExecuteNonQuery();
        if (result == 1)
        {
            Message = " Details updated successfully";
        }
        else
        {
            Message = " Details not updated successfully";
        }
        con.Close();
        return Message;
    }

    [WebMethod]
    public int GetSumActivHrs()
    {
        
        con.Open();

        SqlCommand cmd = new SqlCommand("select count(ActivityName) from Activities", con);
        SqlDataReader reader;
        reader = cmd.ExecuteReader();

        int res;
        if (reader.Read())
        {
            res = reader.GetInt32(0);
        }
        else
        {
            res = 0;
        }
        con.Close();
        return res;

    }

    [WebMethod]
    public int CheckActivitiesByDate(int Daynum, int Monthnum, int Yearnum)
    {

        con.Open();

        SqlCommand cmd = new SqlCommand("select COUNT(*) from dbo.Employee where [DAY] = '"+Daynum+"' and [Month] = '"+Monthnum+"' and [Year]='"+Yearnum+"'", con);
        SqlDataReader reader;
        reader = cmd.ExecuteReader();

        int res;
        if (reader.Read())
        {
            res = reader.GetInt32(0);
        }
        else
        {
            res = 0;
        }
        con.Close();
        return res;

    }
    
}
