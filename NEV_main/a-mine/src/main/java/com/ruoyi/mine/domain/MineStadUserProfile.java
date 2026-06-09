package com.ruoyi.mine.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.apache.ibatis.type.Alias;
import com.ruoyi.common.core.domain.BaseEntity;

@Alias("MineStadUserProfile")
public class MineStadUserProfile extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long profileId;
    private Long userId;
    private String nickName;
    private String idCard;
    private Integer totalEarned;
    private Integer totalSpent;
    private Integer balance;

    public Long getProfileId() { return profileId; }
    public void setProfileId(Long profileId) { this.profileId = profileId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getNickName() { return nickName; }
    public void setNickName(String nickName) { this.nickName = nickName; }

    public String getIdCard() { return idCard; }
    public void setIdCard(String idCard) { this.idCard = idCard; }

    public Integer getTotalEarned() { return totalEarned; }
    public void setTotalEarned(Integer totalEarned) { this.totalEarned = totalEarned; }

    public Integer getTotalSpent() { return totalSpent; }
    public void setTotalSpent(Integer totalSpent) { this.totalSpent = totalSpent; }

    public Integer getBalance() { return balance; }
    public void setBalance(Integer balance) { this.balance = balance; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("userId", getUserId())
                .append("idCard", getIdCard())
                .append("totalEarned", getTotalEarned())
                .append("totalSpent", getTotalSpent())
                .append("balance", getBalance())
                .toString();
    }
}
