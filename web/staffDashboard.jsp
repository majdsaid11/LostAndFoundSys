<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, lostfound.DBConnection" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    if (session == null || !"staff".equals(session.getAttribute("userRole"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    String email = (String) session.getAttribute("userEmail");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard - Lost & Found</title>
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
            width: 250px;
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
.form-control, .form-select {
    background-color: var(--card-bg);
    color: var(--text-color);
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 8px;
    padding: 10px;
}

[data-theme="dark"] .form-control,
[data-theme="dark"] .form-label,
[data-theme="dark"] .form-select {
    color: #fff;
    border-color: #555;
}

.drop-zone {
    border: 2px dashed var(--accent);
    padding: 25px;
    border-radius: 12px;
    text-align: center;
    background-color: rgba(255, 193, 7, 0.05);
    transition: background-color .3s ease;
    cursor: pointer;
}

.drop-zone:hover {
    background-color: rgba(255, 193, 7, 0.1);
}

.drop-zone img {
    display: none;
    max-width: 100%;
    border-radius: 10px;
    margin-top: 10px;
}

.btn-warning {
    background-color: var(--accent);
    border: none;
    color: #000;
    font-weight: 600;
    box-shadow: 0 3px 8px rgba(0,0,0,0.2);
}

        .btn-warning {
            background-color: var(--accent);
            border: none;
            color: #000;
            font-weight: 600;
        }

        .badge { font-size: 0.75rem; }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <div>
        <h4>🏢 Lost & Found AU</h4>
        <p style="font-size: 0.9rem; color: gray;">👤 <%= email %></p>
        <a href="#" class="nav-link active" onclick="showSection('browse')">Browse Items</a>
        <a href="#" class="nav-link" onclick="showSection('report')">Report Found Item</a>
        <a href="#" class="nav-link" onclick="showSection('claims')">View Claims</a>
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
        <h4 class="mb-3">📦 All Items (Lost & Found)</h4>
        <%
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM ITEMS ORDER BY DATE_POSTED DESC");
            ResultSet rs = ps.executeQuery();
        %>
        <table class="table table-hover align-middle text-center">
            <thead>
                <tr>
                    <th>Image</th>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Location</th>
                    <th>Status</th>
                    <th>Posted By</th>
                    <th>Date</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                %>
                <tr>
                    <td><img src="ImageServlet?id=<%= rs.getInt("ITEM_ID") %>" style="width:80px; height:80px; object-fit:cover; border-radius:8px;"></td>
                    <td><%= rs.getString("TITLE") %></td>
                    <td><%= rs.getString("CATEGORY") %></td>
                    <td><%= rs.getString("LOCATION") %></td>
                    <td>
                        <span class="badge <%= "found".equalsIgnoreCase(rs.getString("STATUS")) ? "bg-success" : "bg-danger" %>">
                            <%= rs.getString("STATUS") %>
                        </span>
                    </td>
                    <td><%= rs.getString("POSTED_BY") %></td>
                    <td><%= rs.getDate("DATE_POSTED") %></td>
                    <td>
                        <form action="LostItemServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="itemId" value="<%= rs.getInt("ITEM_ID") %>">
                            <button class="btn btn-danger btn-sm">🗑 Delete</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                    rs.close();
                    ps.close();
                %>
            </tbody>
        </table>
        <%
            conn.close();
        %>
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

    <!-- Claims Section -->
    <div id="claims" class="section" style="display:none;">
        <h4 class="mb-3">🤝 Pending Claims</h4>
        <%
            Connection conn2 = DBConnection.getConnection();
            PreparedStatement ps2 = conn2.prepareStatement(
                "SELECT c.CLAIM_ID, i.TITLE, u.NAME, u.EMAIL, c.CLAIM_STATUS " +
                "FROM CLAIMS c JOIN ITEMS i ON c.ITEM_ID=i.ITEM_ID " +
                "JOIN USERS u ON c.USER_ID=u.USER_ID ORDER BY c.CLAIM_ID DESC");
            ResultSet rs2 = ps2.executeQuery();
        %>
        <table class="table table-hover align-middle text-center">
            <thead>
                <tr>
                    <th>Claim ID</th>
                    <th>Item</th>
                    <th>Claimed By</th>
                    <th>Email</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    boolean hasClaims = false;
                    while (rs2.next()) {
                        hasClaims = true;
                %>
                <tr>
                    <td><%= rs2.getInt("CLAIM_ID") %></td>
                    <td><%= rs2.getString("TITLE") %></td>
                    <td><%= rs2.getString("NAME") %></td>
                    <td><%= rs2.getString("EMAIL") %></td>
                    <td>
                        <span class="badge 
                            <%= "Approved".equalsIgnoreCase(rs2.getString("CLAIM_STATUS")) ? "bg-success" :
                                "Rejected".equalsIgnoreCase(rs2.getString("CLAIM_STATUS")) ? "bg-danger" : "bg-warning text-dark" %>">
                            <%= rs2.getString("CLAIM_STATUS") %>
                        </span>
                    </td>
                    <td>
                        <form action="ClaimServlet" method="post" style="display:inline;">
                            <input type="hidden" name="claimId" value="<%= rs2.getInt("CLAIM_ID") %>">
                            <button name="action" value="approve" class="btn btn-success btn-sm">Approve</button>
                            <button name="action" value="reject" class="btn btn-danger btn-sm">Reject</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                    if (!hasClaims) {
                %>
                <tr><td colspan="6" class="text-center text-muted">No claim requests yet.</td></tr>
                <%
                    }
                    rs2.close(); ps2.close(); conn2.close();
                %>
            </tbody>
        </table>
    </div>

</div>

<script>
    // Drop Zone logic
const dropZone = document.getElementById('dropZone');
const fileInput = document.getElementById('imageInput');
const previewImg = document.getElementById('previewImg');
const dropText = document.getElementById('dropText');

dropZone.addEventListener('click', () => fileInput.click());
fileInput.addEventListener('change', handleFiles);

dropZone.addEventListener('dragover', e => {
    e.preventDefault();
    dropZone.style.backgroundColor = 'rgba(255,193,7,0.1)';
});

dropZone.addEventListener('dragleave', () => {
    dropZone.style.backgroundColor = 'rgba(255,193,7,0.05)';
});

dropZone.addEventListener('drop', e => {
    e.preventDefault();
    dropZone.style.backgroundColor = 'rgba(255,193,7,0.05)';
    const files = e.dataTransfer.files;
    if (files.length) {
        fileInput.files = files;
        handleFiles();
    }
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
</script>
</body>
</html>
