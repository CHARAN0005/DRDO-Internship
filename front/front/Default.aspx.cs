using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace front
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnAdminView_Click(object sender, EventArgs e)
        {
            pnlAdminLogin.Visible = true;
            pnlForm.Visible = false;
            gvAdminRequests.Visible = false;
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            pnlForm.Visible = true;
            pnlAdminLogin.Visible = false;
            gvAdminRequests.Visible = false;
        }

        protected void btnVerifyAdmin_Click(object sender, EventArgs e)
        {
            string empID = txtAdminID.Text.Trim();
            string password = txtAdminPassword.Text.Trim();

            if (string.IsNullOrEmpty(empID) || string.IsNullOrEmpty(password))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please enter both ID and password.');", true);
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["ServiceDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Remove trimming from SQL and compare normally
                string sql = "SELECT admin FROM emp WHERE id = @id AND password = @pass";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    if (!long.TryParse(empID, out long parsedID))
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Invalid Employee ID format');", true);
                        return;
                    }

                    // Always trim from C# side only
                    cmd.Parameters.AddWithValue("@id", parsedID);
                    cmd.Parameters.AddWithValue("@pass", password);

                    try
                    {
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && !string.IsNullOrWhiteSpace(result.ToString()))
                        {
                            LoadServiceRequests();
                            gvAdminRequests.Visible = true;
                            pnlAdminLogin.Visible = false;
                            pnlForm.Visible = false;
                        }
                        else
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Invalid Admin ID or Password.');", true);
                        }
                    }
                    catch (Exception ex)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('DB Error: {ex.Message}');", true);
                    }
                }
            }
        }

        private void LoadServiceRequests()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ServiceDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM ServiceRequests";
                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                try
                {
                    conn.Open();
                    da.Fill(dt);
                    gvAdminRequests.DataSource = dt;
                    gvAdminRequests.DataBind();
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Error: {ex.Message}');", true);
                }
            }
        }

        protected void btnFetch_Click(object sender, EventArgs e)
        {
            string empID = txtEmployeeID.Text.Trim();
            if (string.IsNullOrEmpty(empID)) return;

            string connectionString = ConfigurationManager.ConnectionStrings["ServiceDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT empname, designation, dob, division, phno FROM Employeetable WHERE empid = @EmployeeID";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@EmployeeID", empID);
                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtEmpName.Text = reader["empname"].ToString().Trim();
                            txtDesignation.Text = reader["designation"].ToString();
                            txtPhoneNumber.Text = reader["phno"].ToString();

                            if (DateTime.TryParse(reader["dob"].ToString(), out DateTime dob))
                                txtDOB.Text = dob.ToString("yyyy-MM-dd");

                            string division = reader["division"].ToString().Trim();
                            if (ddlDivision.Items.FindByValue(division) != null)
                                ddlDivision.SelectedValue = division;
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Employee not found.');", true);
                            ClearFields();
                        }
                    }
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ServiceDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"INSERT INTO ServiceRequests 
                       (name, id, designation, phno, division, typeofservice, description, dob, SubmittedOn) 
                       VALUES 
                       (@Name, @EmployeeID, @Designation, @Phone, @Division, @ServiceType, @Description, @DOB, @Sub)";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    try
                    {
                        cmd.Parameters.AddWithValue("@Name", txtEmpName.Text.Trim().PadRight(10).Substring(0, 10));
                        cmd.Parameters.AddWithValue("@EmployeeID", Convert.ToInt64(txtEmployeeID.Text.Trim()));
                        cmd.Parameters.AddWithValue("@Designation", txtDesignation.Text.Trim().PadRight(10).Substring(0, 10));
                        cmd.Parameters.AddWithValue("@Phone", Convert.ToInt64(txtPhoneNumber.Text.Trim()));
                        cmd.Parameters.AddWithValue("@Division", ddlDivision.SelectedValue.Trim().PadRight(10).Substring(0, 10));
                        cmd.Parameters.AddWithValue("@ServiceType", ddlIssueType.SelectedValue.Trim().PadRight(10).Substring(0, 10));
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim().PadRight(10).Substring(0, 10));

                        if (DateTime.TryParse(txtDOB.Text.Trim(), out DateTime dob))
                            cmd.Parameters.AddWithValue("@DOB", dob);
                        else
                            cmd.Parameters.AddWithValue("@DOB", DBNull.Value);

                        cmd.Parameters.AddWithValue("@Sub", DateTime.Now);

                        conn.Open();
                        int rows = cmd.ExecuteNonQuery();

                        if (rows > 0)
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Request saved successfully!');", true);
                            btnClear_Click(sender, e);
                        }
                        else
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Insert failed.');", true);
                        }
                    }
                    catch (Exception ex)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Error: {ex.Message}');", true);
                    }
                }
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearFields();
        }

        private void ClearFields()
        {
            txtEmpName.Text = "";
            txtEmployeeID.Text = "";
            txtDesignation.Text = "";
            txtDOB.Text = "";
            txtPhoneNumber.Text = "";
            ddlDivision.SelectedIndex = 0;
            ddlIssueType.SelectedIndex = 0;
            txtDescription.Text = "";
        }
    }
}
