package com.globaltrade.core.service;

import com.globaltrade.core.dto.TimerJobDTO;
import jakarta.ejb.Local;
import java.util.List;

@Local
public interface TimerManagementService {
    List<TimerJobDTO> getAllTimerJobs();
    void triggerJobNow(String jobType) throws Exception;
    void toggleJobStatus(Long jobId) throws Exception;
}