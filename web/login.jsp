<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Login - Lost &amp; Found</title>

    <!-- Bootstrap 5.3 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <!-- Optional modern font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root{
            /* Background gradient (light) */
            --bg-1: #e3f2fd;
            --bg-2: #bbdefb;

            /* Surfaces & text */
            --card-bg: #ffffff;
            --card-border: rgba(0,0,0,.06);
            --text-color: #212529;

            /* Links & brand */
            --bs-primary: #0d6efd;           /* lets Bootstrap utilities adapt */
            --bs-link-color: #0d6efd;
            --bs-link-hover-color: #0b5ed7;
            --focus-ring: rgba(13,110,253,.28);

            /* Inputs (light) */
            --input-bg: #f8f9fa;
            --input-border: #ced4da;
            --placeholder: #6c757d;

            /* Body text/muted for consistency with Bootstrap */
            --bs-body-bg: #f7f7f8;
            --bs-body-color: #212529;
            --bs-secondary-color: rgba(33,37,41,.65); /* affects .text-muted */
        }

        /* Dark theme (also set data-bs-theme so Bootstrap switches tokens) */
        [data-theme="dark"], [data-bs-theme="dark"]{
            --bg-1: #0f1115;
            --bg-2: #1a1d22;

            --card-bg: rgba(24,24,28,.85);
            --card-border: rgba(255,255,255,.06);
            --text-color: #e6e9ef;

            --bs-body-bg: #0f1115;
            --bs-body-color: #e6e9ef;
            --bs-secondary-color: rgba(230,233,239,.6);

            --bs-primary: #4c8dff;
            --bs-link-color: #82b1ff;
            --bs-link-hover-color: #6aa0ff;
            --focus-ring: rgba(76,141,255,.35);

            --input-bg: #1c1f24;
            --input-border: #3a3f46;
            --placeholder: #a6adbb;
        }

        html, body { height: 100%; }

        body{
            font-family: "Inter", system-ui, -apple-system, Segoe UI, Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
            background: linear-gradient(135deg, var(--bg-1), var(--bg-2)) fixed;
            color: var(--bs-body-color);
            transition: background .35s ease, color .35s ease;
        }

        .container-hero{ min-height: 100dvh; }

        .card{
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 20px;
            box-shadow: 0 12px 36px rgba(0,0,0,.15);
            backdrop-filter: blur(14px) saturate(1.1);
            -webkit-backdrop-filter: blur(14px) saturate(1.1);
            transition: background-color .35s ease, border-color .35s ease;
        }

        h3{
            font-weight: 800;
            color: var(--text-color);
            letter-spacing: -0.02em;
        }

        .form-label{ font-weight: 600; margin-bottom: 6px; }

        .form-control{
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: var(--text-color);
            border-radius: 10px;
            padding: 10px 12px;
            transition: background-color .25s ease, border-color .25s ease, box-shadow .25s ease, color .25s ease;
        }
        .form-control::placeholder{ color: var(--placeholder); }
        .form-control:focus{
            border-color: var(--bs-primary);
            box-shadow: 0 0 0 .2rem var(--focus-ring);
            outline: none;
        }

        .input-group .btn{
            border-radius: 10px;
        }

        .btn-primary{
            border-radius: 12px;
            font-weight: 700;
            background-color: var(--bs-primary);
            border: 1px solid var(--bs-primary);
            padding: .75rem 1rem;
            transition: transform .15s ease, box-shadow .2s ease, background-color .2s ease, border-color .2s ease;
        }
        .btn-primary:hover{
            background-color: var(--bs-link-hover-color);
            border-color: var(--bs-link-hover-color);
            transform: translateY(-1px);
            box-shadow: 0 8px 24px rgba(0,0,0,.12);
        }
        .btn-primary:active{ transform: translateY(0); }

        a{
            color: var(--bs-link-color);
            text-decoration: none;
            font-weight: 600;
        }
        a:hover{ color: var(--bs-link-hover-color); text-decoration: underline; }

        /* Theme toggle */
        .theme-toggle{
            position: fixed;
            top: 18px; right: 18px;
            display: inline-flex; align-items: center; gap: .5rem;
            padding: .55rem .9rem;
            border-radius: 999px;
            border: 1px solid var(--card-border);
            background: var(--card-bg);
            color: var(--text-color);
            font-weight: 700; font-size: .95rem;
            box-shadow: 0 6px 16px rgba(0,0,0,.12);
            cursor: pointer; user-select: none;
            transition: transform .15s ease, box-shadow .2s ease, background-color .2s ease;
        }
        .theme-toggle:hover{ transform: translateY(-1px); }
        .theme-toggle:active{ transform: translateY(0); }
        .theme-toggle .dot{
            width: .85rem; height: .85rem; border-radius: 50%;
            background: #ffd43b;
            box-shadow: inset 0 0 0 2px rgba(0,0,0,.08);
        }
        [data-theme="dark"] .theme-toggle .dot,
        [data-bs-theme="dark"] .theme-toggle .dot{ background: #82cfff; }

        @media (prefers-reduced-motion: reduce){ *{ transition: none !important; } }
    </style>
</head>
<body>
    <!-- Theme Toggle -->
    <button class="theme-toggle" id="themeToggle" type="button" aria-pressed="false" title="Toggle theme">
        <span class="dot" aria-hidden="true"></span><span id="themeLabel">Dark mode</span>
    </button>

    <div class="container container-hero d-flex justify-content-center align-items-center">
        <div class="card p-4 p-md-5" style="max-width: 520px; width: 100%;">
            <h3 class="text-center mb-3">🔐 Login</h3>
            <p class="text-center text-muted mb-4">Welcome back! Please sign in to continue.</p>

            <form action="LoginServlet" method="post" autocomplete="on" novalidate>
    <div class="mb-3">
        <label class="form-label" for="email">Email</label>
        <input id="email" type="email" name="email" class="form-control" placeholder="name@ajmanuni.ac.ae" autocomplete="email" required>
    </div>

    <div class="mb-3">
        <label class="form-label" for="password">Password</label>
        <div class="input-group">
            <input id="password" type="password" name="password" class="form-control" placeholder="••••••••" autocomplete="current-password" required>
            <button class="btn btn-outline-secondary" type="button" id="togglePwd" aria-label="Show password">
                👁️
            </button>
        </div>
    </div>

    <button type="submit" class="btn btn-primary w-100">Login</button>

    <%--  Error message --%>
    <% if (request.getAttribute("loginError") != null) { %>
        <div class="alert alert-danger mt-3 text-center" role="alert">
            <%= request.getAttribute("loginError") %>
        </div>
    <% } %>

    <div class="d-flex justify-content-between align-items-center mt-3">
        <a href="signup.jsp" class="small">Don’t have an account? Sign up</a>
    </div>
</form>
        </div>
    </div>

    <script>
        (function () {
            const body = document.body;
            const toggleBtn = document.getElementById('themeToggle');
            const label = document.getElementById('themeLabel');

            // Theme: saved > system
            const saved = localStorage.getItem('theme');
            const systemPrefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
            const initialDark = saved ? (saved === 'dark') : systemPrefersDark;

            function applyTheme(isDark){
                if(isDark){
                    body.setAttribute('data-theme','dark');
                    body.setAttribute('data-bs-theme','dark'); // let Bootstrap adapt utilities
                    localStorage.setItem('theme','dark');
                    toggleBtn.setAttribute('aria-pressed','true');
                    label.textContent = 'Light mode';
                }else{
                    body.removeAttribute('data-theme');
                    body.setAttribute('data-bs-theme','light');
                    localStorage.setItem('theme','light');
                    toggleBtn.setAttribute('aria-pressed','false');
                    label.textContent = 'Dark mode';
                }
            }
            applyTheme(initialDark);

            toggleBtn.addEventListener('click', () => {
                const makeDark = !body.hasAttribute('data-theme');
                applyTheme(makeDark);
            });

            // Show/hide password
            const pwd = document.getElementById('password');
            const togglePwd = document.getElementById('togglePwd');
            togglePwd.addEventListener('click', () => {
                const isPwd = pwd.getAttribute('type') === 'password';
                pwd.setAttribute('type', isPwd ? 'text' : 'password');
                togglePwd.setAttribute('aria-label', isPwd ? 'Hide password' : 'Show password');
            });
        })();
    </script>
</body>
</html>
