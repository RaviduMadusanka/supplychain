<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 Access Denied :: NexTrade SCM</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = { theme: { extend: { colors: {
        ink:'#12172B', sidebar:'#0B1220', primary:'#2547D0', primarydk:'#1B34A6',
        teal:'#0EA5A4', amber:'#E0572B', line:'#E4E7EF', bg:'#F5F6FA'
      }, fontFamily: { display:['"Space Grotesk"','sans-serif'], body:['Inter','sans-serif'], mono:['"JetBrains Mono"','monospace'] } } } }
    </script>
    <style>
      body{ font-family:'Inter',sans-serif; }
      .font-display{ font-family:'Space Grotesk',sans-serif; }
      .font-mono{ font-family:'JetBrains Mono',monospace; }
    </style>
</head>
<body class="bg-bg text-ink min-h-screen flex items-center justify-center p-6 relative overflow-hidden">
    
    <!-- Background pattern -->
    <div class="absolute inset-0 opacity-[0.03]" style="background-image:radial-gradient(circle at 1px 1px, #12172B 1px, transparent 0); background-size:24px 24px;"></div>

    <div class="relative max-w-md w-full bg-white rounded-2xl shadow-xl shadow-ink/5 p-10 text-center border border-line">
        <div class="w-16 h-16 rounded-full bg-amber/10 flex items-center justify-center mx-auto mb-6">
            <svg class="w-8 h-8 text-amber" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
        </div>
        
        <h1 class="font-display text-6xl font-bold text-ink mb-2">403</h1>
        <h2 class="font-display text-xl font-semibold mb-3">Access Denied</h2>
        
        <p class="text-sm text-ink/60 mb-8 leading-relaxed">
            You do not have the required permissions to access this module. Your current role lacks the necessary authorization level.
        </p>
        
        <div class="flex flex-col gap-3">
            <button onclick="window.history.back()" class="w-full py-2.5 rounded-lg bg-primary hover:bg-primarydk transition text-white text-sm font-semibold shadow-sm shadow-primary/30">
                Go Back
            </button>
            <a href="login.jsp" class="w-full py-2.5 rounded-lg border border-line hover:bg-bg transition text-ink text-sm font-semibold">
                Sign in as different user
            </a>
        </div>
    </div>
</body>
</html>
