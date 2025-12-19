package com.example.labequipment.repository;

import com.example.labequipment.entity.BorrowRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface BorrowRecordRepository extends JpaRepository<BorrowRecord, Long> {
    List<BorrowRecord> findByUserName(String userName);
    List<BorrowRecord> findByStatus(String status);
    List<BorrowRecord> findByDeviceId(Long deviceId);
}
