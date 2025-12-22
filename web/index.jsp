<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Lost & Found Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <style>
        :root {
            --overlay-bg: rgba(255, 255, 255, 0.85);
            --overlay-border: rgba(0, 0, 0, 0.06);
            --text-color: #212529;
            --bs-body-bg: #f7f7f8;
        }

        [data-theme="dark"] {
            --overlay-bg: rgba(24, 24, 28, 0.78);
            --overlay-border: rgba(255, 255, 255, 0.06);
            --text-color: #f5f5f5;
            --bs-body-bg: #0f1115;
        }

        body {
            background: var(--bs-body-bg);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-color);
            transition: background-color .3s, color .3s;
        }

        .overlay {
            background: var(--overlay-bg);
            border: 1px solid var(--overlay-border);
            border-radius: 18px;
            padding: 2rem;
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
        }

        .theme-toggle {
            position: fixed;
            top: 20px;
            right: 20px;
            background: var(--overlay-bg);
            border: none;
            border-radius: 30px;
            padding: 8px 16px;
            font-weight: 600;
            cursor: pointer;
        }

        /* Dark theme overrides */
        [data-theme="dark"] .text-muted {
            color: #ccc !important;
        }

        [data-theme="dark"] .form-control {
            background-color: #1c1c1f;
            color: #f5f5f5;
            border-color: #444;
        }

        [data-theme="dark"] .form-control::placeholder {
            color: #aaa;
        }

        [data-theme="dark"] .btn-dark {
            background-color: #333;
            border-color: #555;
            color: #f5f5f5;
        }

        [data-theme="dark"] .alert-danger {
            background-color: #661919;
            color: #f5f5f5;
            border-color: #aa2e2e;
        }
    </style>
</head>

<body>
    <button class="theme-toggle" onclick="toggleTheme()">🌓 Toggle Theme</button>

    <div class="container vh-100 d-flex justify-content-center align-items-center">
        <div class="overlay text-center" style="max-width: 480px; width: 100%;">
            <h2 class="mb-3">Lost & Found System</h2>
            <p class="text-muted mb-4">Report or recover lost items within ***** University</p>

            <!-- Student buttons -->
            <div class="d-grid gap-3 mb-4">
                <form action="login.jsp">
                    <button class="btn btn-primary btn-lg w-100" type="submit">🎓 Student Login</button>
                </form>
                <form action="signup.jsp">
                    <button class="btn btn-success btn-lg w-100" type="submit">📝 Student Sign Up</button>
                </form>
            </div>

            
        </div>
    </div>

    <script>
        function showStaffBox() {
            document.getElementById("staffBox").style.display = "block";
        }

        function toggleTheme() {
            const body = document.body;
            const isDark = body.hasAttribute("data-theme");
            if (isDark) {
                body.removeAttribute("data-theme");
                localStorage.removeItem("theme");
            } else {
                body.setAttribute("data-theme", "dark");
                localStorage.setItem("theme", "dark");
            }
        }

        if (localStorage.getItem("theme") === "dark") {
            document.body.setAttribute("data-theme", "dark");
        }
    </script>
</body>
</html>