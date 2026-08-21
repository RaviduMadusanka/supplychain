package com.globaltrade.core.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

public class TimerJobDTO implements Serializable {
    private Long id;
    private String jobName;
    private String jobType;
    private String creationType;
    private String scheduleExpression;
    private Integer intervalSeconds;
    private LocalDateTime lastRunAt;
    private LocalDateTime nextRunAt;
    private String lastRunStatus;
    private Boolean isPersistent;
    private String status;

    public TimerJobDTO() {}

    public TimerJobDTO(Long id, String jobName, String jobType, String creationType, String scheduleExpression,
                       Integer intervalSeconds, LocalDateTime lastRunAt, LocalDateTime nextRunAt,
                       String lastRunStatus, Boolean isPersistent, String status) {
        this.id = id;
        this.jobName = jobName;
        this.jobType = jobType;
        this.creationType = creationType;
        this.scheduleExpression = scheduleExpression;
        this.intervalSeconds = intervalSeconds;
        this.lastRunAt = lastRunAt;
        this.nextRunAt = nextRunAt;
        this.lastRunStatus = lastRunStatus;
        this.isPersistent = isPersistent;
        this.status = status;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getJobName() { return jobName; }
    public void setJobName(String jobName) { this.jobName = jobName; }
    public String getJobType() { return jobType; }
    public void setJobType(String jobType) { this.jobType = jobType; }
    public String getCreationType() { return creationType; }
    public void setCreationType(String creationType) { this.creationType = creationType; }
    public String getScheduleExpression() { return scheduleExpression; }
    public void setScheduleExpression(String scheduleExpression) { this.scheduleExpression = scheduleExpression; }
    public Integer getIntervalSeconds() { return intervalSeconds; }
    public void setIntervalSeconds(Integer intervalSeconds) { this.intervalSeconds = intervalSeconds; }
    public LocalDateTime getLastRunAt() { return lastRunAt; }
    public void setLastRunAt(LocalDateTime lastRunAt) { this.lastRunAt = lastRunAt; }
    public LocalDateTime getNextRunAt() { return nextRunAt; }
    public void setNextRunAt(LocalDateTime nextRunAt) { this.nextRunAt = nextRunAt; }
    public String getLastRunStatus() { return lastRunStatus; }
    public void setLastRunStatus(String lastRunStatus) { this.lastRunStatus = lastRunStatus; }
    public Boolean getIsPersistent() { return isPersistent; }
    public void setIsPersistent(Boolean isPersistent) { this.isPersistent = isPersistent; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}