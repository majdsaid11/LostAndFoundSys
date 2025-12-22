<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Sign Up - Lost &amp; Found</title>

    <!-- Bootstrap 5.3 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <!-- Modern font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-1: #fdfbfb;
            --bg-2: #ebedee;
            --card-bg: #ffffff;
            --card-border: rgba(0,0,0,.06);
            --text-color: #212529;
            --bs-body-bg: #f7f7f8;
            --bs-body-color: #212529;
            --bs-success: #26d07c;
            --input-bg: #f8f9fa;
            --input-border: #ced4da;
            --placeholder: #6c757d;
            --focus-ring: rgba(32,201,151,.28);
        }

        [data-theme="dark"], [data-bs-theme="dark"] {
            --bg-1: #121212;
            --bg-2: #1e1e1e;
            --card-bg: rgba(24,24,28,.85);
            --card-border: rgba(255,255,255,.06);
            --text-color: #e6e9ef;
            --bs-body-bg: #0f1115;
            --bs-body-color: #e6e9ef;
            --bs-success: #22c773;
            --input-bg: #1c1f24;
            --input-border: #3a3f46;
            --placeholder: #a6adbb;
            --focus-ring: rgba(34,199,115,.35);
        }

        html, body { height: 100%; }

        body {
            font-family: "Inter", system-ui, -apple-system, Segoe UI, Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
            background: linear-gradient(135deg, var(--bg-1), var(--bg-2)) fixed;
            color: var(--bs-body-color);
            transition: background .35s ease, color .35s ease;
        }

        .container-hero { min-height: 100dvh; }

        .card {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 18px;
            box-shadow: 0 12px 36px rgba(0,0,0,.15);
            backdrop-filter: blur(14px) saturate(1.1);
        }

        h3 {
            font-weight: 800;
            color: var(--text-color);
            letter-spacing: -0.02em;
        }

        .form-label { font-weight: 600; margin-bottom: 6px; }

        .form-control {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: var(--text-color);
            border-radius: 10px;
            padding: 10px 12px;
        }
        .form-control::placeholder { color: var(--placeholder); }
        .form-control:focus {
            border-color: var(--bs-success);
            box-shadow: 0 0 0 .2rem var(--focus-ring);
            outline: none;
        }

        .btn-success {
            border-radius: 12px;
            font-weight: 700;
            background-color: var(--bs-success);
            border: 1px solid var(--bs-success);
            padding: .75rem 1rem;
            transition: transform .15s ease, box-shadow .2s ease;
        }
        .btn-success:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 24px rgba(0,0,0,.12);
            filter: brightness(0.95);
        }

        a {
            color: #198754;
            text-decoration: none;
            font-weight: 600;
        }
        a:hover { text-decoration: underline; }

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
            cursor: pointer;
        }
        .theme-toggle .dot {
            width: .85rem; height: .85rem; border-radius: 50%;
            background: #ffd43b;
        }
        [data-theme="dark"] .theme-toggle .dot { background: #82cfff; }

        @media (prefers-reduced-motion: reduce){ *{ transition: none !important; } }
    </style>
</head>
<body>
    <!-- Theme Toggle -->
    <button class="theme-toggle" id="themeToggle" type="button">
        <span class="dot"></span><span id="themeLabel">Dark mode</span>
    </button>

    <div class="container container-hero d-flex justify-content-center align-items-center">
        <div class="card p-4 p-md-5" style="max-width: 520px; width: 100%;">
            <h3 class="text-center mb-2">📝 Student Sign Up</h3>
            <p class="text-center text-muted mb-4">Join the Ajman University Lost &amp; Found community.</p>

            <form action="SignupServlet" method="post" autocomplete="on" novalidate>
                <div class="mb-3">
                    <label class="form-label" for="name">Full Name</label>
                    <input id="name" type="text" name="name" class="form-control" placeholder="Your full name" required>
                </div>

                <div class="mb-3">
                    <label class="form-label" for="email">Email</label>
                    <input id="email" type="email" name="email" class="form-control" placeholder="name@ajmanuni.ac.ae" autocomplete="email" required>
                </div>

                <div class="mb-4">
                    <label class="form-label" for="password">Password</label>
                    <div class="input-group">
                        <input id="password" type="password" name="password" class="form-control" placeholder="••••••••" autocomplete="new-password" required>
                        <button class="btn btn-outline-secondary" type="button" id="togglePwd" aria-label="Show password">👁️</button>
                    </div>
                </div>

                <button type="submit" class="btn btn-success w-100">Sign Up</button>

                <div class="text-center mt-3">
                    <a href="login.jsp">🔐 Already have an account? Login</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        (function () {
            const body = document.body;
            const toggleBtn = document.getElementById('themeToggle');
            const label = document.getElementById('themeLabel');
            const saved = localStorage.getItem('theme');
            const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
            const initialDark = saved ? (saved === 'dark') : systemPrefersDark;

            function applyTheme(isDark){
                if(isDark){
                    body.setAttribute('data-theme','dark');
                    body.setAttribute('data-bs-theme','dark');
                    localStorage.setItem('theme','dark');
                    label.textContent = 'Light mode';
                }else{
                    body.removeAttribute('data-theme');
                    body.setAttribute('data-bs-theme','light');
                    localStorage.setItem('theme','light');
                    label.textContent = 'Dark mode';
                }
            }
            applyTheme(initialDark);
            toggleBtn.addEventListener('click', () => applyTheme(!body.hasAttribute('data-theme')));

            // Password visibility toggle
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
