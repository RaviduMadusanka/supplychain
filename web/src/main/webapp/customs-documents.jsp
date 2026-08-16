<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String pageTitle = "Customs Documents";
  String pageSubtitle = "3 documents \u00b7 1 pending approval";
  String activePage = "customs";
  String userName = "Nadeesha Perera";
  String userRole = "Admin";
%>
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/sidebar.jspf" %>

  <div class="flex items-center justify-between mb-5">
    <div class="flex items-center gap-1 p-1 bg-line/50 rounded-lg text-xs font-mono uppercase">
      <button class="px-3 py-1.5 rounded-md bg-white shadow-sm font-semibold">All</button>
      <button class="px-3 py-1.5 rounded-md text-ink/50">Pending</button>
      <button class="px-3 py-1.5 rounded-md text-ink/50">Approved</button>
    </div>
    <button onclick="toggleModal('submitDocModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primarydk transition">+ Submit Document</button>
  </div>

  <div class="card overflow-hidden">
    <table class="w-full text-sm">
      <thead><tr class="text-left text-ink/40 text-xs font-mono uppercase tracking-wide border-b border-line bg-bg/50">
        <th class="px-5 py-3 font-medium">Document</th><th class="px-5 py-3 font-medium">Shipment</th><th class="px-5 py-3 font-medium">Country</th><th class="px-5 py-3 font-medium">Submitted</th><th class="px-5 py-3 font-medium">Status</th><th class="px-5 py-3 font-medium text-right">Actions</th>
      </tr></thead>
      <tbody class="divide-y divide-line">
        <tr class="hover:bg-bg/60">
          <td class="px-5 py-3.5"><div class="font-medium">Bill of Lading</div><div class="font-mono text-xs text-ink/40">BOL-2026-0001</div></td>
          <td class="px-5 py-3.5 font-mono text-xs text-ink/60">SHP-20260702-001</td>
          <td class="px-5 py-3.5 text-ink/60">Sri Lanka</td>
          <td class="px-5 py-3.5 text-xs text-ink/40 font-mono">02 Jul 11:00</td>
          <td class="px-5 py-3.5"><span class="tag tag-teal"><span class="tag-dot"></span>Approved</span></td>
          <td class="px-5 py-3.5 text-right text-xs text-primary font-medium">View</td>
        </tr>
        <tr class="hover:bg-bg/60">
          <td class="px-5 py-3.5"><div class="font-medium">Certificate of Origin</div><div class="font-mono text-xs text-ink/40">COO-2026-0002</div></td>
          <td class="px-5 py-3.5 font-mono text-xs text-ink/60">SHP-20260706-002</td>
          <td class="px-5 py-3.5 text-ink/60">Sweden</td>
          <td class="px-5 py-3.5 text-xs text-ink/40 font-mono">06 Jul 10:00</td>
          <td class="px-5 py-3.5"><span class="tag tag-teal"><span class="tag-dot"></span>Approved</span></td>
          <td class="px-5 py-3.5 text-right text-xs text-primary font-medium">View</td>
        </tr>
        <tr class="hover:bg-bg/60 bg-ambersoft/30">
          <td class="px-5 py-3.5"><div class="font-medium">Import Declaration</div><div class="font-mono text-xs text-ink/40">IMD-2026-0003</div></td>
          <td class="px-5 py-3.5 font-mono text-xs text-ink/60">SHP-20260711-003</td>
          <td class="px-5 py-3.5 text-ink/60">UAE</td>
          <td class="px-5 py-3.5 text-xs text-ink/40 font-mono">11 Jul 14:00</td>
          <td class="px-5 py-3.5"><span class="tag tag-amber"><span class="tag-dot"></span>Pending</span></td>
          <td class="px-5 py-3.5 text-right space-x-2">
            <button class="text-xs text-teal font-medium">Approve</button>
            <button class="text-xs text-amber font-medium">Reject</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>

<script>
function toggleModal(id) {
  const modal = document.getElementById(id);
  if (modal.classList.contains('hidden')) {
    modal.classList.remove('hidden');
    modal.classList.add('flex');
  } else {
    modal.classList.add('hidden');
    modal.classList.remove('flex');
  }
}
</script>

<!-- Submit Document Modal -->
<div id="submitDocModal" class="hidden fixed inset-0 z-50 items-center justify-center bg-ink/50 backdrop-blur-sm">
  <div class="bg-white rounded-xl shadow-xl border border-line w-full max-w-md p-6">
    <div class="flex items-center justify-between mb-4">
      <h3 class="font-display font-semibold text-lg">Submit Customs Document</h3>
      <button onclick="toggleModal('submitDocModal')" class="text-ink/50 hover:text-ink">&times;</button>
    </div>
    <form class="space-y-4">
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Document Type</label>
        <select class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary bg-white">
          <option>Bill of Lading</option>
          <option>Certificate of Origin</option>
          <option>Import Declaration</option>
        </select>
      </div>
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">Shipment Reference</label>
        <input type="text" placeholder="SHP-" class="w-full px-3 py-2 border border-line rounded-lg text-sm focus:outline-none focus:border-primary font-mono">
      </div>
      <div>
        <label class="block text-xs font-medium text-ink/60 mb-1">File Upload</label>
        <div class="border-2 border-dashed border-line rounded-lg p-6 text-center hover:border-primary transition cursor-pointer">
          <svg class="w-8 h-8 text-ink/30 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"></path></svg>
          <span class="text-sm font-medium text-ink/60">Click to upload or drag PDF here</span>
        </div>
      </div>
      <div class="mt-6 flex justify-end gap-3">
        <button type="button" onclick="toggleModal('submitDocModal')" class="px-4 py-2 rounded-lg border border-line text-sm font-medium hover:bg-bg">Cancel</button>
        <button type="button" onclick="toggleModal('submitDocModal')" class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-medium hover:bg-primarydk transition">Submit Document</button>
      </div>
    </form>
  </div>
</div>

<%@ include file="includes/footer.jspf" %>
