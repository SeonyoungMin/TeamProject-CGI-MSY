package com.team404.domain;

import java.sql.Timestamp;

import com.fasterxml.jackson.annotation.JsonFormat;

public class Image {
	private Integer imageNo;
	private String fileName;
	private String filePath;
	private String entitlyType;
	private int entityId;
	private int isThumnail;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
	private Timestamp createdTime;
	
	public Image(String fileName, String filePath, String entitlyType, int entityId, int isThumnail) {
		super();
		this.fileName = fileName;
		this.filePath = filePath;
		this.entitlyType = entitlyType;
		this.entityId = entityId;
		this.isThumnail = isThumnail;
	}

	public Integer getImageNo() {
		return imageNo;
	}

	public void setImageNo(Integer imageNo) {
		this.imageNo = imageNo;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getEntitlyType() {
		return entitlyType;
	}

	public void setEntitlyType(String entitlyType) {
		this.entitlyType = entitlyType;
	}

	public int getEntityId() {
		return entityId;
	}

	public void setEntityId(int entityId) {
		this.entityId = entityId;
	}

	public int getIsThumnail() {
		return isThumnail;
	}

	public void setIsThumnail(int isThumnail) {
		this.isThumnail = isThumnail;
	}

	public Timestamp getCreatedTime() {
		return createdTime;
	}

	public void setCreatedTime(Timestamp createdTime) {
		this.createdTime = createdTime;
	}

	@Override
	public String toString() {
		return "Image [imageNo=" + imageNo + ", fileName=" + fileName + ", filePath=" + filePath + ", entitlyType="
				+ entitlyType + ", entityId=" + entityId + ", isThumnail=" + isThumnail + ", createdTime=" + createdTime
				+ "]";
	}
	
	
	
}
