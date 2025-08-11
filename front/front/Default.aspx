<%@ Page Title="Service Request Form" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="front._Default" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <style>
    .grid-full-container {
      width: 100%;
      padding: 20px;
      margin-top: 20px;
      display: flex;
      justify-content: center;
    }

    .styled-grid-wide {
      width: 95%;
      border-collapse: collapse;
      font-family: 'Segoe UI', sans-serif;
      font-size: 14px;
      box-shadow: 0 0 15px rgba(0,0,0,0.1);
    }

    .styled-grid-wide th {
      background-color: #007bff;
      color: white;
      padding: 12px;
      text-align: left;
      white-space: nowrap;
    }

    .styled-grid-wide td {
      padding: 10px 12px;
      border-bottom: 1px solid #ddd;
      white-space: nowrap;
    }

    .styled-grid-wide tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    .styled-grid-wide tr:hover {
      background-color: #f1f1f1;
    }

    .form-container {
      max-width: 640px;
      background: linear-gradient(to bottom, #ffffff, #f4f4f4);
      padding: 30px 35px;
      border-radius: 10px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.1);
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      margin: 40px auto;
      border: 1px solid #ddd;
    }

    h2 {
      text-align: center;
      color: #2c3e50;
      margin-bottom: 30px;
      font-size: 26px;
      font-weight: 600;
      text-shadow: 0 1px 0 #fff;
    }

    .form-table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0 18px;
      margin: 0 auto;
    }

    .form-label {
      font-weight: 600;
      padding-right: 15px;
      vertical-align: middle;
      color: #2d2d2d;
      width: 160px;
      white-space: nowrap;
    }

    td > input[type="text"],
    td > input[type="tel"],
    td > textarea,
    td > select {
      width: 100%;
      padding: 10px 12px;
      border: 1px solid #ccc;
      border-radius: 6px;
      font-size: 15px;
      font-family: inherit;
      transition: border-color 0.3s ease, box-shadow 0.3s ease;
      background-color: #fff;
    }

    td > input:focus,
    td > textarea:focus,
    td > select:focus {
      border-color: #3498db;
      box-shadow: 0 0 8px rgba(52, 152, 219, 0.4);
      outline: none;
    }

    textarea {
      resize: vertical;
    }

    .form-buttons {
      padding-left: 160px;
      display: flex;
      gap: 14px;
    }

    .btn-submit, .btn-clear {
      background-color: #0078d4;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 5px;
      font-weight: 600;
      font-size: 14px;
      cursor: pointer;
      transition: background-color 0.3s ease, transform 0.2s ease;
    }

    .btn-submit:hover {
      background-color: #005a9e;
      transform: translateY(-1px);
    }

    .btn-clear {
      background-color: #6c757d;
    }

    .btn-clear:hover {
      background-color: #495057;
    }
  </style>

  <div class="form-container">
    <h2>Service Request Form</h2>
    <div style="text-align: right; margin-bottom: 10px;">
      <asp:Button ID="btnAdminView" runat="server" Text="Admin View" CssClass="btn-submit" OnClick="btnAdminView_Click" />
    </div>

    <!-- Admin Login Panel -->
    <asp:Panel ID="pnlAdminLogin" runat="server" CssClass="admin-panel" Visible="false">
      <asp:Label ID="lblAdminPrompt" runat="server" Text="Enter Admin Employee ID:" />
      <asp:TextBox ID="txtAdminID" runat="server" Width="150px" />
      <br /><br />

      <asp:Label ID="lblAdminPassword" runat="server" Text="Enter Password:" />
      <asp:TextBox ID="txtAdminPassword" runat="server" TextMode="Password" Width="150px" />
      <br /><br />

      <asp:Button ID="btnVerifyAdmin" runat="server" Text="Verify" CssClass="btn-submit" OnClick="btnVerifyAdmin_Click" />
      <asp:Button ID="btnBack" runat="server" Text="Back to Form" CssClass="btn-clear" OnClick="btnBack_Click" />
    </asp:Panel>

    <div class="grid-full-container">
      <asp:GridView ID="gvAdminRequests" runat="server" CssClass="styled-grid-wide" AutoGenerateColumns="true" GridLines="None" />
    </div>

    <asp:Panel ID="pnlForm" runat="server">
      <table class="form-table">
        <tr>
          <td class="form-label">Employee Name:</td>
          <td><asp:TextBox ID="txtEmpName" runat="server" /></td>
        </tr>
        <tr>
          <td class="form-label">Employee ID:</td>
          <td>
            <asp:TextBox ID="txtEmployeeID" runat="server" />
            <asp:Button ID="btnFetch" runat="server" Text="Fetch" OnClick="btnFetch_Click" Style="margin-left:10px;" />
          </td>
        </tr>
        <tr>
          <td class="form-label">Designation:</td>
          <td><asp:TextBox ID="txtDesignation" runat="server" /></td>
        </tr>
        <tr>
          <td class="form-label">Date of Birth:</td>
          <td><asp:TextBox ID="txtDOB" runat="server" TextMode="Date" /></td>
        </tr>
        <tr>
          <td class="form-label">Division:</td>
          <td>
            <asp:DropDownList ID="ddlDivision" runat="server">
              <asp:ListItem Text="-- Select --" Value="" />
              <asp:ListItem Text="IT" Value="IT" />
              <asp:ListItem Text="HR" Value="HR" />
              <asp:ListItem Text="Finance" Value="Finance" />
              <asp:ListItem Text="Operations" Value="Operations" />
              <asp:ListItem Text="Sales" Value="Sales" />
            </asp:DropDownList>
          </td>
        </tr>
        <tr>
          <td class="form-label">Phone Number:</td>
          <td><asp:TextBox ID="txtPhoneNumber" runat="server" TextMode="Phone" /></td>
        </tr>
        <tr>
          <td class="form-label">Type of Issue:</td>
          <td>
            <asp:DropDownList ID="ddlIssueType" runat="server">
              <asp:ListItem Text="-- Select --" Value="" />
              <asp:ListItem Text="Technical Support" Value="Technical Support" />
              <asp:ListItem Text="Hardware Failure" Value="Hardware Failure" />
              <asp:ListItem Text="Software Request" Value="Software Request" />
              <asp:ListItem Text="Network Issue" Value="Network Issue" />
              <asp:ListItem Text="Other" Value="Other" />
            </asp:DropDownList>
          </td>
        </tr>
        <tr>
          <td class="form-label">Description:</td>
          <td><asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" Columns="40" /></td>
        </tr>
        <tr>
          <td></td>
          <td class="form-buttons">
            <asp:Button ID="btnSubmit" CssClass="btn-submit" runat="server" Text="Submit" OnClick="btnSubmit_Click" />
            <asp:Button ID="btnClear" CssClass="btn-clear" runat="server" Text="Clear Form" OnClick="btnClear_Click" CausesValidation="False" />
          </td>
        </tr>
      </table>
    </asp:Panel>
  </div>
</asp:Content>
