<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.sql.*, lostfound.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard - Lost & Found</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --sidebar-bg: #f8f9fa;
            --sidebar-text: #212529;
            --bg-color: #ffffff;
            --card-bg: #ffffff;
            --text-color: #212529;
            --accent: #ffc107;
            --my-item-bg: #fff8e1;
        }

        [data-theme="dark"] {
            --sidebar-bg: #1e1e1e;
            --sidebar-text: #f5f5f5;
            --bg-color: #121212;
            --card-bg: #1e1e1e;
            --text-color: #f5f5f5;
            --accent: #ffcc00;
            --my-item-bg: #2a2a1f;
        }
        [data-theme="dark"] .card {
    background-color: #1f1f1f !important;
    color: #fff !important;
    border: 1px solid #333 !important;
}

[data-theme="dark"] .card h5,
[data-theme="dark"] .card p,
[data-theme="dark"] .card .text-muted {
    color: #f5f5f5 !important;
}
.form-select {
    background-color: var(--input-bg);
    color: var(--text-color);
    border-color: var(--input-border);
}

[data-theme="dark"] .form-select {
    background-color: #2a2a2a;
    color: #fff;
    border-color: #555;
}
.form-control {
    background-color: var(--input-bg);
    color: var(--text-color);
    border-color: var(--input-border);
}

[data-theme="dark"] .form-control {
    background-color: #2a2a2a;
    color: #fff;
    border-color: #555;
}


        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: 0.4s ease;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        .sidebar {
            width: 270px;
            background-color: var(--sidebar-bg);
            color: var(--sidebar-text);
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            border-right: 1px solid rgba(0,0,0,0.1);
        }

        .sidebar h4 { font-weight: 700; margin-bottom: 1.5rem; }

        .nav-link {
            color: var(--sidebar-text);
            font-weight: 500;
            border-radius: 8px;
            padding: 10px 15px;
            margin-bottom: 8px;
            transition: 0.3s;
        }

        .nav-link:hover, .nav-link.active {
            background-color: var(--accent);
            color: #000;
        }

        .main {
            flex-grow: 1;
            overflow-y: auto;
            padding: 30px;
            background-color: var(--bg-color);
        }

        .card {
            background-color: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border: none;
            margin-bottom: 20px;
        }

        .btn-warning {
            background-color: var(--accent);
            border: none;
            color: #000;
            font-weight: 600;
        }

        .drop-zone {
            border: 2px dashed #ffc107;
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            background-color: rgba(255,193,7,0.05);
            transition: background-color .3s ease;
            cursor: pointer;
        }
        .drop-zone:hover { background-color: rgba(255,193,7,0.1); }
        .drop-zone img {
            display: none;
            max-width: 100%;
            border-radius: 10px;
            margin-top: 10px;
        }

        .my-item { background-color: var(--my-item-bg) !important; }
        .badge { font-size: 0.75rem; }
    </style>
</head>
<body>
<%
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String email = (String) session.getAttribute("userEmail");
%>

<!-- Sidebar -->
<div class="sidebar">
    <div>
        <h4>Lost & Found AU</h4><br>
        <p style="font-size: 0.9rem; color: gray; margin-bottom: 1rem;">
            👤 <%= session.getAttribute("userEmail") != null ? session.getAttribute("userEmail") : "Guest" %>
        </p>
        <a href="#" class="nav-link active" onclick="showSection('browse')">Browse Items</a>
        <a href="#" class="nav-link" onclick="showSection('report')">Report Lost Item</a>
        <a href="#" class="nav-link" onclick="showSection('myreports')">My Reports</a>
        <a href="#" class="nav-link" onclick="showSection('myclaims')">My Claims</a>
    </div>
    <div>
        <button class="theme-toggle btn btn-sm btn-outline-secondary" onclick="toggleTheme()">🌓</button>
        <a href="logout.jsp" class="btn btn-outline-danger w-100 mt-2">Logout</a>
    </div>
</div>

<!-- Main -->
<div class="main">
    <!-- Browse Section -->
    <div id="browse" class="section">
        <h4 class="mb-3">🧭 Browse All Items</h4>
        <%
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM ITEMS ORDER BY DATE_POSTED DESC");
            ResultSet rs = ps.executeQuery();
        %>
        <div class="row">
        <%
            boolean hasItems = false;
            while (rs.next()) {
                hasItems = true;
                boolean isMine = rs.getString("POSTED_BY").equalsIgnoreCase(email);
                int itemId = rs.getInt("ITEM_ID");
        %>
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm <%= isMine ? "my-item" : "" %>">
                    <img src="ImageServlet?id=<%= itemId %>" class="card-img-top" style="height:200px; object-fit:cover;">
                    <div class="card-body">
                        <p class="small text-muted">
    📍 <%= rs.getString("LOCATION") %> </p>
                        <h5 class="card-title"><%= rs.getString("TITLE") %></h5>
                        <p class="card-text"><%= rs.getString("DESCRIPTION") %></p>
                        <p class="small text-muted">
                            📁 <%= rs.getString("CATEGORY") %> | 📅 <%= rs.getDate("DATE_POSTED") %>
                        </p>
                        
                        <span class="badge <%= "found".equalsIgnoreCase(rs.getString("STATUS")) ? "bg-success" : "bg-danger" %>">
                            <%= rs.getString("STATUS") %>
                        </span>
                        <% if (isMine) { %><span class="badge bg-warning text-dark">My Post</span><% } %>
                        <p class="small text-muted mt-2">👤 Posted by: <%= rs.getString("POSTED_BY") %></p>
                        <form action="ClaimServlet" method="post" style="display:inline;">
    <input type="hidden" name="itemId" value="<%= rs.getInt("ITEM_ID") %>">
    <button type="submit" class="btn btn-sm btn-success mt-2">Claim</button>
</form>
                    </div>
                </div>
            </div>
        <%
            }
            if (!hasItems) {
        %>
            <p>No items found.</p>
        <%
            }
            rs.close(); ps.close(); conn.close();
        %>
        </div>
    </div>

    <!-- Report Section -->
    <div id="report" class="section" style="display:none;">
        <h4 class="mb-3">🧾 Report Lost Item</h4>
        <div class="card p-4">
            <form action="LostItemServlet" method="post" enctype="multipart/form-data">
                <div class="mb-3">
                    <label class="form-label">Item Title</label>
                    <input type="text" name="title" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" required></textarea>
                </div>
                
             <div class="mb-3">
    <label class="form-label">Category</label>
    <select name="category" class="form-select" required>
        <option value="">-- Select Category --</option>
        <option value="personal items">Personal Items</option>
        <option value="documents">Documents</option>
        <option value="electronics">Electronics</option>
        <option value="accessories">Accessories</option>
        <option value="clothing">Clothing</option>
        <option value="books">Books</option>
        <option value="keys">Keys</option>
        <option value="wallets">Wallets</option>
        <option value="others">Others</option>
    </select>
</div>
                <div class="mb-3">
  <label class="form-label">Location (Building)</label>
  <select name="location" class="form-select" required>
    <option value="">-- Select Building --</option>
    <option value="J1">J1</option>
    <option value="J2">J2</option>
    <option value="Overall Campus Ground">Overall Campus Ground</option>
    <option value="Sports Complex">Sports Complex</option>
    <option value="Student Hub">Student Hub</option>
    <option value="SHZ">SHZ</option>
  </select>
</div>

                <!-- Drop Zone Upload -->
                <div class="mb-3">
                    <label class="form-label">Upload Image (optional)</label>
                    <div id="dropZone" class="drop-zone">
                        <p id="dropText" class="text-muted mb-2">📷 Drag & drop an image here or click to upload</p>
                        <img id="previewImg" src="#" alt="Preview">
                        <input type="file" name="image" id="imageInput" accept="image/*" hidden>
                    </div>
                </div>

                <button type="submit" class="btn btn-warning w-100">Report Lost Item</button>
            </form>
        </div>
    </div>

    <!-- My Reports Section -->
  <!-- My Reports Section -->
<div id="myreports" class="section" style="display:none;">
    <h4 class="mb-3">📦 My Reported Lost Items</h4>

    <%
        Connection conn2 = DBConnection.getConnection();
        PreparedStatement ps2 = conn2.prepareStatement(
            "SELECT ITEM_ID, TITLE, DESCRIPTION, CATEGORY, DATE_POSTED FROM ITEMS WHERE STATUS='lost' AND POSTED_BY=? ORDER BY DATE_POSTED DESC"
        );
        ps2.setString(1, email);
        ResultSet rs2 = ps2.executeQuery();
    %>

    <table class="table table-hover align-middle">
        <thead>
            <tr>
                <th>Title</th>
                <th>Description</th>
                <th>Category</th>
                <th>Date</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                boolean hasLost = false;
                while (rs2.next()) {
                    hasLost = true;
            %>
                <tr>
                    <td><%= rs2.getString("TITLE") %></td>
                    <td><%= rs2.getString("DESCRIPTION") %></td>
                    <td><%= rs2.getString("CATEGORY") %></td>
                    <td><%= rs2.getDate("DATE_POSTED") %></td>
                    <td>
                        <form action="LostItemServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="itemId" value="<%= rs2.getInt("ITEM_ID") %>">
                            <button type="submit" class="btn btn-sm btn-danger" 
                                    onclick="return confirm('Are you sure you want to delete this item?')">
                                🗑 Delete
                            </button>
                        </form>
                    </td>
                </tr>
            <%
                }
                if (!hasLost) {
            %>
                <tr><td colspan="5" class="text-center text-muted">No lost items reported yet.</td></tr>
            <%
                }
                rs2.close();
                ps2.close();
                conn2.close();
            %>
        </tbody>
    </table>
</div>
        <div id="myclaims" class="section" style="display:none;">
    <h4 class="mb-3">🤝 My Claim Requests</h4>

    <%
        Connection conn3 = DBConnection.getConnection();
        PreparedStatement ps3 = conn3.prepareStatement(
            "SELECT c.CLAIM_ID, i.TITLE, i.CATEGORY, c.CLAIM_STATUS, c.VERIFICATION_DETAILS " +
            "FROM CLAIMS c JOIN ITEMS i ON c.ITEM_ID = i.ITEM_ID " +
            "WHERE c.USER_ID = (SELECT USER_ID FROM USERS WHERE EMAIL=?)"
        );
        ps3.setString(1, email);
        ResultSet rs3 = ps3.executeQuery();
    %>

    <table class="table table-striped align-middle">
        <thead>
            <tr>
                <th>Item</th>
                <th>Category</th>
                <th>Details</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
        <%
            boolean hasClaims = false;
            while (rs3.next()) {
                hasClaims = true;
        %>
            <tr>
                <td><%= rs3.getString("TITLE") %></td>
                <td><%= rs3.getString("CATEGORY") %></td>
                <td><%= rs3.getString("VERIFICATION_DETAILS") %></td>
                <td>
                    <span class="badge <%= "Approved".equalsIgnoreCase(rs3.getString("CLAIM_STATUS")) ? "bg-success" :
                        "Rejected".equalsIgnoreCase(rs3.getString("CLAIM_STATUS")) ? "bg-danger" : "bg-warning text-dark" %>">
                        <%= rs3.getString("CLAIM_STATUS") %>
                    </span>
                </td>
            </tr>
        <%
            }
            if (!hasClaims) {
        %>
            <tr><td colspan="4" class="text-center text-muted">No claim requests yet.</td></tr>
        <%
            }
            rs3.close(); ps3.close(); conn3.close();
        %>
        </tbody>
    </table>
</div>
</div>

<script>
function showSection(id) {
    document.querySelectorAll('.section').forEach(s => s.style.display = 'none');
    document.getElementById(id).style.display = 'block';
    document.querySelectorAll('.nav-link').forEach(n => n.classList.remove('active'));
    event.target.classList.add('active');
}

function toggleTheme() {
    const body = document.body;
    const dark = body.getAttribute('data-theme') === 'dark';
    if (dark) {
        body.removeAttribute('data-theme');
        localStorage.removeItem('theme');
    } else {
        body.setAttribute('data-theme', 'dark');
        localStorage.setItem('theme', 'dark');
    }
}
if (localStorage.getItem('theme') === 'dark') document.body.setAttribute('data-theme', 'dark');

// Drop Zone logic
const dropZone = document.getElementById('dropZone');
const fileInput = document.getElementById('imageInput');
const previewImg = document.getElementById('previewImg');
const dropText = document.getElementById('dropText');

dropZone.addEventListener('click', () => fileInput.click());
fileInput.addEventListener('change', handleFiles);
dropZone.addEventListener('dragover', e => { e.preventDefault(); dropZone.style.backgroundColor = 'rgba(255,193,7,0.1)'; });
dropZone.addEventListener('dragleave', () => dropZone.style.backgroundColor = 'rgba(255,193,7,0.05)');
dropZone.addEventListener('drop', e => {
    e.preventDefault();
    dropZone.style.backgroundColor = 'rgba(255,193,7,0.05)';
    const files = e.dataTransfer.files;
    if (files.length) { fileInput.files = files; handleFiles(); }
});

function handleFiles() {
    const [file] = fileInput.files;
    if (file) {
        const reader = new FileReader();
        reader.onload = e => {
            previewImg.src = e.target.result;
            previewImg.style.display = 'block';
            dropText.style.display = 'none';
        };
        reader.readAsDataURL(file);
    } else {
        previewImg.style.display = 'none';
        dropText.style.display = 'block';
    }
}
</script>
</body>
</html>
