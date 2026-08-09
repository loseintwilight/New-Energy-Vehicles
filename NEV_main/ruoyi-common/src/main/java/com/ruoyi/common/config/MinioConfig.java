package com.ruoyi.common.config;

import io.minio.MinioClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * MinIO 对象存储配置
 * 
 * @author ruoyi
 */
@Configuration
public class MinioConfig
{
    @Value("${minio.endpoint}")
    private String endpoint;

    @Value("${minio.accessKey}")
    private String accessKey;

    @Value("${minio.secretKey}")
    private String secretKey;

    @Value("${minio.bucketName}")
    private String bucketName;

    @Value("${minio.publicEndpoint:}")
    private String publicEndpoint;

    public String getEndpoint()
    {
        return endpoint;
    }

    public String getAccessKey()
    {
        return accessKey;
    }

    public String getSecretKey()
    {
        return secretKey;
    }

    public String getBucketName()
    {
        return bucketName;
    }

    public String getPublicEndpoint()
    {
        return publicEndpoint != null && !publicEndpoint.isEmpty() ? publicEndpoint : endpoint;
    }

    @Bean
    public MinioClient minioClient()
    {
        return MinioClient.builder()
                .endpoint(endpoint)
                .credentials(accessKey, secretKey)
                .build();
    }
}