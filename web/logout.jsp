<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Prevent caching so users can't go back to authenticated pages
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma","no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    if (session != null) { session.invalidate(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Logging out…</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="robots" content="noindex" />

    <!-- Bootstrap 5.3 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <!-- Optional modern font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">

    <!-- Meta refresh as a non-JS fallback -->
    <meta http-equiv="refresh" content="3;url=index.jsp">

    <style>
        :root{
            /* Background (light) */
            --bg-1: #f1f3f5;
            --bg-2: #e9ecef;

            /* Card & text */
            --card-bg: #ffffff;
            --card-border: rgba(0,0,0,.06);
            --text-color: #212529;

            /* Bootstrap aware */
            --bs-body-bg: #f7f7f8;
            --bs-body-color: #212529;
            --bs-secondary-color: rgba(33,37,41,.65);

            --bs-primary: #0d6efd;
            --focus-ring: rgba(13,110,253,.28);
        }

        [data-theme="dark"], [data-bs-theme="dark"]{
            --bg-1: #0f1115;
            --bg-2: #171a20;

            --card-bg: rgba(24,24,28,.85);
            --card-border: rgba(255,255,255,.06);
            --text-color: #e6e9ef;

            --bs-body-bg: #0f1115;
            --bs-body-color: #e6e9ef;
            --bs-secondary-color: rgba(230,233,239,.6);

            --bs-primary: #4c8dff;
            --focus-ring: rgba(76,141,255,.35);
        }

        html, body { height: 100%; }

        body{
            font-family: "Inter", system-ui, -apple-system, Segoe UI, Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
            background: linear-gradient(135deg, var(--bg-1), var(--bg-2)) fixed;
            color: var(--bs-body-color);
            transition: background .35s ease, color .35s ease;
        }

        .container-hero{ min-height: 100dvh; }

        .overlay{
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 18px;
            padding: clamp(1.5rem, 3vw, 2.25rem);
            box-shadow: 0 12px 36px rgba(0,0,0,.15);
            backdrop-filter: blur(14px) saturate(1.1);
            -webkit-backdrop-filter: blur(14px) saturate(1.1);
            transition: background-color .35s ease, border-color .35s ease;
            max-width: 520px; width: 100%;
        }

        h1{
            font-weight: 800;
            letter-spacing: -0.02em;
            color: var(--text-color);
        }

        .text-muted{ color: var(--bs-secondary-color) !important; }

        .btn{
            border-radius: 12px;
            font-weight: 700;
            padding: .75rem 1rem;
        }
        .btn-primary{
            background-color: var(--bs-primary);
            border-color: var(--bs-primary);
            transition: transform .15s ease, box-shadow .2s ease, background-color .2s ease, border-color .2s ease;
        }
        .btn-primary:hover{
            transform: translateY(-1px);
            box-shadow: 0 8px 24px rgba(0,0,0,.12);
        }

        /* Theme toggle */
        .theme-toggle{
            position: fixed; top: 18px; right: 18px;
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
    </style>
</head>
<body>
    <!-- Theme Toggle -->
    <button class="theme-toggle" id="themeToggle" type="button" aria-pressed="false" title="Toggle theme">
        <span class="dot" aria-hidden="true"></span><span id="themeLabel">Dark mode</span>
    </button>

    <div class="container container-hero d-flex justify-content-center align-items-center">
        <div class="overlay text-center">
            <div class="mb-3">
                <div class="spinner-border" role="status" aria-hidden="true"></div>
            </div>
            <h1 class="mb-2">You’ve been logged out</h1>
            <p class="text-muted mb-4">
                Redirecting to the home page in <span id="count">3</span> seconds…
            </p>
            <a href="index.jsp" class="btn btn-primary">Go to Home now</a>
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
                    body.setAttribute('data-bs-theme','dark');
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

            // Countdown + JS redirect
            const countEl = document.getElementById('count');
            let remaining = 3;
            const timer = setInterval(() => {
                remaining -= 1;
                if (remaining <= 0) {
                    clearInterval(timer);
                    window.location.replace('index.jsp');
                } else {
                    countEl.textContent = remaining;
                }
            }, 1000);
        })();
    </script>
</body>
</html>

