package com.globaltrade.core.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "timer_jobs")
public class TimerJob implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "job_name", nullable = false, length = 150)
    private String jobName;

    @Column(name = "job_type", length = 100)
    private String jobType;

    @Column(name = "creation_type", length = 20)
    private String creationType;

    @Column(name = "schedule_expression", length = 150)
    private String scheduleExpression;

    @Column(name = "interval_seconds")
    private Integer intervalSeconds;

    @Column(name = "last_run_at")
    private LocalDateTime lastRunAt;

    @Column(name = "next_run_at")
    private LocalDateTime nextRunAt;

    @Column(name = "last_run_status", length = 50)
    private String lastRunStatus;

    @Column(name = "is_persistent")
    private Boolean isPersistent = true;

    @Column(length = 50)
    private String status = "SCHEDULED";

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
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
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
