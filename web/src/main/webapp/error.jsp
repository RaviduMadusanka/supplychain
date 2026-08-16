<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Error :: NexTrade SCM</title>
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
<body class="bg-bg text-ink min-h-screen flex flex-col p-6 relative overflow-hidden">
    
    <!-- Background pattern -->
    <div class="absolute inset-0 opacity-[0.03]" style="background-image:radial-gradient(circle at 1px 1px, #12172B 1px, transparent 0); background-size:24px 24px;"></div>

    <div class="relative flex-1 flex flex-col items-center justify-center">
        <div class="max-w-2xl w-full bg-white rounded-2xl shadow-xl shadow-ink/5 p-10 border border-line">
            
            <div class="flex items-center gap-4 mb-6 pb-6 border-b border-line">
                <div class="w-12 h-12 rounded-full bg-amber/10 flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-amber" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
                </div>
                <div>
                    <h1 class="font-display text-2xl font-bold text-ink">System Exception</h1>
                    <p class="text-sm text-ink/60">An unexpected error occurred while processing your request.</p>
                </div>
            </div>
            
            <div class="bg-bg/50 border border-line rounded-lg p-4 mb-8 overflow-x-auto">
                <div class="font-mono text-[11px] text-ink/40 uppercase tracking-wide mb-2">Error Details</div>
                <div class="font-mono text-sm text-ink/80 whitespace-pre-wrap">
<% 
    if (exception != null) {
        out.println(exception.getMessage());
    } else {
        out.println("Unknown Error (500 Internal Server Error)");
    }
%>
                </div>
            </div>
            
            <div class="flex justify-end gap-3">
                <button onclick="window.history.back()" class="px-5 py-2.5 rounded-lg border border-line hover:bg-bg transition text-ink text-sm font-semibold">
                    Go Back
                </button>
                <a href="dashboard-admin.jsp" class="px-5 py-2.5 rounded-lg bg-primary hover:bg-primarydk transition text-white text-sm font-semibold shadow-sm shadow-primary/30">
                    Return to Dashboard
                </a>
            </div>
        </div>
    </div>
</body>
</html>
