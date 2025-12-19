package com.example.labequipment.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "devices")
public class Device {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    
    @Column(columnDefinition = "TEXT")
    private String image;
    
    private String status; // available, borrowed
    
    private String type; // optical, electronic, consumable, other
    
    private Integer maxDuration;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    private LocalDateTime createTime;

    @PrePersist
    protected void onCreate() {
        createTime = LocalDateTime.now();
    }
}
