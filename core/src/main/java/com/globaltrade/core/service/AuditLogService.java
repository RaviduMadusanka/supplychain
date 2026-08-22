package com.globaltrade.core.service;

import com.globaltrade.core.dto.AuditLogDTO;
import com.globaltrade.core.dto.ExceptionLogDTO;
import jakarta.ejb.Local;
import java.util.List;

@Local
public interface AuditLogService {
    List<AuditLogDTO> getRecentAuditLogs(int maxResults);
    List<ExceptionLogDTO> getRecentExceptionLogs(int maxResults);
}