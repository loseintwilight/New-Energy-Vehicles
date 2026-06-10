package com.ruoyi.common.utils.file;

import com.ruoyi.common.config.MinioConfig;
import io.minio.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.UUID;

/**
 * MinIO 文件上传工具类
 * 
 * @author ruoyi
 */
@Component
public class MinioUtils
{
    private static final Logger log = LoggerFactory.getLogger(MinioUtils.class);

    @Autowired
    private MinioClient minioClient;

    @Autowired
    private MinioConfig minioConfig;

    /**
     * 上传文件到 MinIO
     *
     * @param file 上传的文件
     * @return 文件访问URL
     * @throws Exception
     */
    public String uploadFile(MultipartFile file) throws Exception
    {
        // 确保桶存在
        ensureBucketExists();

        // 生成唯一文件名
        String originalFilename = file.getOriginalFilename();
        String suffix = "";
        if (originalFilename != null && originalFilename.contains("."))
        {
            suffix = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        String fileName = UUID.randomUUID().toString().replaceAll("-", "") + suffix;

        // 按日期分目录存储
        String objectName = java.time.LocalDate.now().toString() + "/" + fileName;

        // 上传
        try (InputStream inputStream = file.getInputStream())
        {
            PutObjectArgs args = PutObjectArgs.builder()
                    .bucket(minioConfig.getBucketName())
                    .object(objectName)
                    .stream(inputStream, file.getSize(), -1)
                    .contentType(file.getContentType())
                    .build();
            minioClient.putObject(args);
        }

        log.info("MinIO 上传成功: bucket={}, object={}", minioConfig.getBucketName(), objectName);

        // 返回简洁的存储路径（不带签名参数），拼接为可直接访问的URL
        String url = minioConfig.getEndpoint() + "/" + minioConfig.getBucketName() + "/" + objectName;
        return url;
    }

    /**
     * 确保桶存在，不存在则创建并设置公开读策略
     */
    private void ensureBucketExists() throws Exception
    {
        boolean exists = minioClient.bucketExists(
                BucketExistsArgs.builder()
                        .bucket(minioConfig.getBucketName())
                        .build());
        if (!exists)
        {
            minioClient.makeBucket(
                    MakeBucketArgs.builder()
                            .bucket(minioConfig.getBucketName())
                            .build());
            log.info("MinIO 桶已创建: {}", minioConfig.getBucketName());
        }

        // 设置桶的匿名读策略，使直接URL可以访问
        setBucketPublicPolicy();
    }

    /**
     * 设置桶为公开读策略（无需签名即可访问文件）
     */
    private void setBucketPublicPolicy() throws Exception
    {
        StringBuilder policy = new StringBuilder();
        policy.append("{\n");
        policy.append("  \"Version\": \"2012-10-17\",\n");
        policy.append("  \"Statement\": [\n");
        policy.append("    {\n");
        policy.append("      \"Effect\": \"Allow\",\n");
        policy.append("      \"Principal\": {\"AWS\": [\"*\"]},\n");
        policy.append("      \"Action\": [\"s3:GetObject\"],\n");
        policy.append("      \"Resource\": [\"arn:aws:s3:::").append(minioConfig.getBucketName()).append("/*\"]\n");
        policy.append("    }\n");
        policy.append("  ]\n");
        policy.append("}\n");

        minioClient.setBucketPolicy(
                SetBucketPolicyArgs.builder()
                        .bucket(minioConfig.getBucketName())
                        .config(policy.toString())
                        .build());
        log.info("MinIO 桶已设置为公开读: {}", minioConfig.getBucketName());
    }
}