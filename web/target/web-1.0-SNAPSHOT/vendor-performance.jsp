<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Vendor Performance";
  String pageSubtitle = "Evaluation period ending 30 Jun 2026";
  String activePage = "vendorperf";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="grid grid-cols-1 lg:grid-cols-3 gap-5 mb-6">
    <!-- Apex Tech -->
    <div class="card p-5">
      <div class="flex items-center justify-between mb-4">
        <div><div class="font-medium text-sm">Apex Tech Components</div><div class="font-mono text-xs text-ink/40">VEN-001</div></div>
        <span class="tag tag-teal"><span class="tag-dot"></span>4.50</span>
      </div>
      <div class="space-y-3">
        <div>
          <div class="flex justify-between text-xs mb-1"><span class="text-ink/50">On-time delivery</span><span class="font-mono font-medium">92.5%</span></div>
          <div class="h-1.5 bg-line rounded-full overflow-hidden"><div class="h-full bg-teal" style="width:92.5%"></div></div>
        </div>
        <div>
          <div class="flex justify-between text-xs mb-1"><span class="text-ink/50">Quality score</span><span class="font-mono font-medium">88.0%</span></div>
          <div class="h-1.5 bg-line rounded-full overflow-hidden"><div class="h-full bg-primary" style="width:88%"></div></div>
        </div>
        <div>
          <div class="flex justify-between text-xs mb-1"><span class="text-ink/50">Avg. response time</span><span class="font-mono font-medium">4.5 hrs</span></div>
        </div>
      </div>
    </div>
    <!-- Global Parts -->
    <div class="card p-5">
      <div class="flex items-center justify-between mb-4">
        <div><div class="font-medium text-sm">Global Parts Ltd</div><div class="font-mono text-xs text-ink/40">VEN-002</div></div>
        <span class="tag tag-teal"><span class="tag-dot"></span>4.10</span>
      </div>
      <div class="space-y-3">
        <div>
          <div class="flex justify-between text-xs mb-1"><span class="text-ink/50">On-time delivery</span><span class="font-mono font-medium">85.0%</span></div>
          <div class="h-1.5 bg-line rounded-full overflow-hidden"><div class="h-full bg-teal" style="width:85%"></div></div>
        </div>
        <div>
          <div class="flex justify-between text-xs mb-1"><span class="text-ink/50">Quality score</span><span class="font-mono font-medium">90.0%</span></div>
          <div class="h-1.5 bg-line rounded-full overflow-hidden"><div class="h-full bg-primary" style="width:90%"></div></div>
        </div>
        <div>
          <div class="flex justify-between text-xs mb-1"><span class="text-ink/50">Avg. response time</span><span class="font-mono font-medium">6.0 hrs</span></div>
        </div>
      </div>
    </div>
    <!-- Pacific Freight -->
    <div class="card p-5 ring-1 ring-amber/30">
      <div class="flex items-center justify-between mb-4">
        <div><div class="font-medium text-sm">Pacific Freight Supplies</div><div class="font-mono text-xs text-ink/40">VEN-003</div></div>
        <span class="tag tag-amber"><span class="tag-dot"></span>3.80</span>
      </div>
      <div class="space-y-3">
        <div>
          <div class="flex justify-between text-xs mb-1"><span class="text-ink/50">On-time delivery</span><span class="font-mono font-medium">78.3%</span></div>
          <div class="h-1.5 bg-line rounded-full overflow-hidden"><div class="h-full bg-amber" style="width:78.3%"></div></div>
        </div>
        <div>
          <div class="flex justify-between text-xs mb-1"><span class="text-ink/50">Quality score</span><span class="font-mono font-medium">82.5%</span></div>
          <div class="h-1.5 bg-line rounded-full overflow-hidden"><div class="h-full bg-primary" style="width:82.5%"></div></div>
        </div>
        <div>
          <div class="flex justify-between text-xs mb-1"><span class="text-ink/50">Avg. response time</span><span class="font-mono font-medium">8.2 hrs</span></div>
        </div>
      </div>
    </div>
  </div>

  <div class="card">
    <div class="px-5 py-4 border-b border-line"><h3 class="font-display font-semibold text-sm">Evaluation History</h3></div>
    <table class="w-full text-sm">
      <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line">
        <th class="px-5 py-2.5 font-medium">Vendor</th><th class="px-5 py-2.5 font-medium">Date</th><th class="px-5 py-2.5 font-medium">On-time</th><th class="px-5 py-2.5 font-medium">Quality</th><th class="px-5 py-2.5 font-medium">Response</th><th class="px-5 py-2.5 font-medium">Overall</th>
      </tr></thead>
      <tbody class="divide-y divide-line">
        <tr class="hover:bg-bg/60"><td class="px-5 py-3">Apex Tech Components</td><td class="px-5 py-3 font-mono text-xs text-ink/50">2026-06-30</td><td class="px-5 py-3">92.50%</td><td class="px-5 py-3">88.00%</td><td class="px-5 py-3">4.50 hrs</td><td class="px-5 py-3 font-semibold text-teal">4.50</td></tr>
        <tr class="hover:bg-bg/60"><td class="px-5 py-3">Global Parts Ltd</td><td class="px-5 py-3 font-mono text-xs text-ink/50">2026-06-30</td><td class="px-5 py-3">85.00%</td><td class="px-5 py-3">90.00%</td><td class="px-5 py-3">6.00 hrs</td><td class="px-5 py-3 font-semibold text-teal">4.10</td></tr>
        <tr class="hover:bg-bg/60"><td class="px-5 py-3">Pacific Freight Supplies</td><td class="px-5 py-3 font-mono text-xs text-ink/50">2026-06-30</td><td class="px-5 py-3">78.30%</td><td class="px-5 py-3">82.50%</td><td class="px-5 py-3">8.20 hrs</td><td class="px-5 py-3 font-semibold text-amber">3.80</td></tr>
      </tbody>
    </table>
  </div>

<%@ include file="includes/footer.jspf" %>
