package com.ruoyi.newcar.domain;

import lombok.Data;

import java.util.Date;

@Data
public class FinancePlan {
    private Long planId;

    private Long vehicleId;

    private String planType;

    private String planName;

    private Double totalPrice;

    private Double downPayment;

    private Double monthlyPayment;

    private Integer months;

    private Double interestRate;

    private Double totalInterest;

    private Double totalPayable;

    private String provider;

    private Integer isActive;

    private Integer sortOrder;

    private Date createTime;

    private Date updateTime;
}